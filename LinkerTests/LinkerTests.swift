//
//  LinkerTests.swift
//  LinkerTests
//
//  Created by Anton Heestand on 2022-07-27.
//

import XCTest
@testable import Linker

class LinkerTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testSignUp() async throws {
        
        let authServiceManager: AuthServiceManager = .mocked
        
        try await authServiceManager.signUp(email: "test@test.com", password: "123Abc!")
    }
    
    func testSignIn() async throws {
        
        let authServiceManager: AuthServiceManager = .mocked
        
        try await authServiceManager.signIn(email: "test@test.com", password: "123Abc!")
    }
}
