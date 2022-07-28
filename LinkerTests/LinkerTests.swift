//
//  LinkerTests.swift
//  LinkerTests
//
//  Created by Anton Heestand on 2022-07-27.
//

import XCTest
@testable import Linker

class LinkerTests: XCTestCase {
    
    var auth: AuthServiceManager!

    override func setUpWithError() throws {
        auth = AuthServiceManager(service: MainAuthService())
    }

    override func tearDownWithError() throws {
        auth = nil
    }
    
    func testSignIn() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        try await auth.signOut()
    }
    
    func testChangeName() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        
        let name = "Test \(Int.random(in: 1...100))"
        try await auth.changeName(name)
        XCTAssertEqual(auth.user?.name, name)
        
        try await auth.signOut()
        XCTAssertNil(auth.user)
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        XCTAssertEqual(auth.user?.name, name)
    }
}
