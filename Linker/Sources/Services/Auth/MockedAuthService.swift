//
//  MockedAuthService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import Foundation
import Combine

final class MockedAuthService: AuthService {
    
    var authenticated: Bool = false {
        didSet {
            authenticatedSubject.value = authenticated
        }
    }
    
    lazy var authenticatedSubject = CurrentValueSubject<Bool, Never>(authenticated)
    
    func signIn(email: String, password: String) async throws {
        
        /// Mocked delay
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
        
        authenticated = true
    }
    
    func signOut() async throws {
        
        /// Mocked delay
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
        
        authenticated = false
    }
    
    func signUp(email: String, password: String) async throws {
        
        /// Mocked delay
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
        
        authenticated = true
    }
    
    func resetPassword(email: String) async throws {
        
        /// Mocked delay
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
    }
}
