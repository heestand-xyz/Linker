//
//  MockedAuthService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import UIKit
import Combine

final class MockedAuthService: AuthService {
    
    var authenticated: Bool = false {
        didSet {
            authenticatedSubject.value = authenticated
        }
    }
    
    var user: AuthUser?
    
    lazy var authenticatedSubject = CurrentValueSubject<Bool, Never>(authenticated)
    
    func signIn(email: String, password: String) async throws {
        
        await delay()
        
        authenticated = true
        self.user = AuthUser(email: email)
    }
    
    func signOut() async throws {
        
        await delay()
        
        authenticated = false
        self.user = nil
    }
    
    func signUp(email: String, password: String) async throws {
        
        await delay()
        
        authenticated = true
        self.user = AuthUser(email: email)
    }
    
    func changePhoto(_ image: UIImage) async throws {
        
        await delay()
        
        user?.photo = image
    }
    
    func changeName(_ name: String) async throws {
        
        await delay()
        
        user?.name = name
    }
    
    private func delay() async {
        
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
    }
}
