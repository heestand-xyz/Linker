//
//  AuthServiceManager.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import UIKit
import Combine

final class AuthServiceManager: ObservableObject, AuthService {
    
    @Published var authenticated: Bool
    
    var authenticatedSubject: CurrentValueSubject<Bool, Never> {
        service.authenticatedSubject
    }
    
    @Published var user: AuthUser?
    
    var userSubject: CurrentValueSubject<AuthUser?, Never> {
        service.userSubject
    }
    
    let service: AuthService
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(service: AuthService) {
        
        self.service = service
        authenticated = service.authenticated
        
        setup()
    }
}

// MARK: - Setup

extension AuthServiceManager {
    
    private func setup() {
        
        service.authenticatedSubject
            .sink { [weak self] authenticated in
                
                DispatchQueue.main.async {
                    self?.authenticated = authenticated
                }
            }
            .store(in: &cancelBag)
        
        service.userSubject
            .sink { [weak self] user in
                
                DispatchQueue.main.async {
                    self?.user = user
                }
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Service

extension AuthServiceManager {
    
    func signIn(email: String, password: String) async throws {
        try await service.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await service.signOut()
    }
    
    func signUp(email: String, password: String) async throws {
        try await service.signUp(email: email, password: password)
    }
    
    func changePhoto(_ image: UIImage) async throws {
        try await service.changePhoto(image)
    }
    
    func changeName(_ name: String) async throws {
        try await service.changeName(name)
    }
}

// MARK: - Mock

extension AuthServiceManager {
    static let mocked = AuthServiceManager(service: MockedAuthService())
}
