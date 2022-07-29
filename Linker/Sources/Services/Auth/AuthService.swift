//
//  AuthService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import UIKit
import Combine

protocol AuthService {
    
    var authenticated: Bool { get set }
    var authenticatedSubject: CurrentValueSubject<Bool, Never> { get }
    
    var user: AuthUser? { get }
    var userSubject: CurrentValueSubject<AuthUser?, Never> { get }

    func signIn(email: String, password: String) async throws
    func signOut() async throws

    func signUp(email: String, password: String) async throws
    
    func changePhoto(_ image: UIImage) async throws
    
    func changeName(_ name: String) async throws
}
