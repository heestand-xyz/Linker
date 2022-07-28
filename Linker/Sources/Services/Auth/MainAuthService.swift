//
//  MainAuthService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseStorage

final class MainAuthService: AuthService {
    
    var authenticated: Bool = false {
        didSet {
            authenticatedSubject.value = authenticated
        }
    }
    
    lazy var authenticatedSubject = CurrentValueSubject<Bool, Never>(authenticated)
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    var user: AuthUser? {
        didSet {
            authenticated = user != nil
        }
    }
    
    init() {
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            
            guard let user: User = user else {
                self?.user = nil
                return
            }
            
            Task { [self] in
                do {
                    self?.user = try await AuthUser(user: user)
                } catch {
                    print("Auth Error:", error)
                }
            }
        }
    }
    
    deinit {
        
        guard let handle = handle else { return }
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

extension MainAuthService {
    
    enum AuthError: Error {
        case notAuthorized
        case badImageData
        case badMetadata
        case badURL
    }
    
    func signIn(email: String, password: String) async throws {
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume()
            }
        }
    }
    
    func signOut() async throws {
        
        try Auth.auth().signOut()
        
        user = nil
    }
    
    func signUp(email: String, password: String) async throws {
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume()
            }
        }
    }
    
    func changePhoto(_ image: UIImage) async throws {
        
        guard authenticated, let user = Auth.auth().currentUser else {
            throw AuthError.notAuthorized
        }
        
        let url = try await uploadPhoto(image)
        
        let changeRequest = user.createProfileChangeRequest()
        
        changeRequest.photoURL = url
        self.user?.photo = image
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            
            changeRequest.commitChanges { error in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume()
            }
        }
    }
    
    private func uploadPhoto(_ image: UIImage) async throws -> URL {
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw AuthError.badImageData
        }
        
        let photoName = "\(UUID().uuidString).jpg"
        
        let storage = Storage.storage()
        
        let reference = storage.reference().child("Profiles/\(photoName)")
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let uploadTask = reference.putData(data, metadata: nil) { (metadata, error) in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let metadata = metadata else {
                    continuation.resume(throwing: AuthError.badMetadata)
                    return
                }
                                
                reference.downloadURL { (url, error) in
                    
                    guard let url: URL = url else {
                        continuation.resume(throwing: AuthError.badURL)
                        return
                    }
                    
                    continuation.resume(returning: url)
                }
            }
            
            uploadTask.resume()
        }
    }
    
    func changeName(_ name: String) async throws {
        
        guard authenticated, let user = Auth.auth().currentUser else {
            throw AuthError.notAuthorized
        }
        
        let changeRequest = user.createProfileChangeRequest()
        
        changeRequest.displayName = name
        self.user?.name = name
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            
            changeRequest.commitChanges { error in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume()
            }
        }
    }
}
