//
//  AuthServiceManager.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import Foundation
import Combine

final class AuthServiceManager: ObservableObject, AuthService {
    
    @Published var authenticated: Bool
    
    lazy var authenticatedSubject = CurrentValueSubject<Bool, Never>(authenticated)
    
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
    
    func resetPassword(email: String) async throws {
        try await service.resetPassword(email: email)
    }
}

// MARK: - Mock

extension AuthServiceManager {
    static let mocked = AuthServiceManager(service: MockedAuthService())
}
