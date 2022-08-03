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
    var content: ContentServiceManager!

    override func setUpWithError() throws {
        auth = AuthServiceManager(service: MainAuthService())
        content = ContentServiceManager(service: MainContentService())
    }

    override func tearDownWithError() throws {
        auth = nil
        content = nil
    }
    
    func testSignIn() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        try await auth.signOut()
    }
    
    func testChangeName() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        
        let name = "Test \(Int.random(in: 1...100))"
        try await auth.changeName(name)
        XCTAssertEqual(auth.userSubject.value?.name, name)
        
        try await auth.signOut()
        XCTAssertNil(auth.userSubject.value)
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        XCTAssertEqual(auth.userSubject.value?.name, name)
        
        try await auth.signOut()
    }
    
    func testGetPosts() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        
        try await content.refresh()
        XCTAssertNotEqual(content.postsSubject.value.count, 0)
        
        try await auth.signOut()
    }
    
    func testPost() async throws {
        
        try await auth.signIn(email: "test@test.com", password: "123Abc!")
        
        let expectation = XCTestExpectation(description: "sync")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.1)

        guard let user = auth.user else {
            XCTFail()
            return
        }
        
        let url = URL(string: "https://google.com/")!
        let text = "Test \(Int.random(in: 0...1000))"
        
        let postUser = Post.User(name: user.name ?? "",
                                 id: user.id)
        let post = Post(id: UUID().uuidString,
                        user: postUser,
                        url: url,
                        text: text)
        
        try await content.create(post: post)
        
        guard let livePost = content.postsSubject.value.first(where: { post in
            post.user.id == user.id && post.text == text
        }) else {
            XCTFail()
            return
        }
                
        try await content.delete(post: livePost)
        
        try await auth.signOut()
    }
}
