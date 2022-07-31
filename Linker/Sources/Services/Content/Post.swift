//
//  Post.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation

struct Post: Identifiable {
    
    struct User {
        let name: String
        let id: String
    }
    let user: User

    let date: Date
    var id: Date {
        date
    }
    
    let url: URL
    let text: String
}

extension Post {
    
    static let mocked = Post(user: Post.User(name: "Tester", id: "test"),
                             date: .now,
                             url: URL(string: "https://google.com/")!,
                             text: "Test")
}

extension Array where Element == Post {
    
    static let mocked: [Post] = [
        Post(user: Post.User(name: "Tester", id: "test"),
             date: .now,
             url: URL(string: "https://google.com/")!,
             text: "Google Test"),
        Post(user: Post.User(name: "Tester", id: "test"),
             date: .now,
             url: URL(string: "https://apple.com/")!,
             text: "Apple Test"),
        Post(user: Post.User(name: "Tester", id: "test"),
             date: .now,
             url: URL(string: "https://nanameue.jp/")!,
             text: "Hello"),
    ]
}
