//
//  AuthService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import Foundation
import Combine

protocol AuthService {
    
    var authenticated: Bool { get set }
    var authenticatedSubject: CurrentValueSubject<Bool, Never> { get }

    func signIn(email: String, password: String) async throws
    func signOut() async throws

    func signUp(email: String, password: String) async throws
    
    func resetPassword(email: String) async throws
}
