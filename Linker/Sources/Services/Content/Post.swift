//
//  Post.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation

struct Post: Identifiable {
    
    var id: String
    
    struct User {
        let name: String
        let id: String
        static let mocked = User(name: "Tester", id: "test")
    }
    let user: User

    let date: Date
    
    let url: URL
    let text: String
    
    init(id: String, user: User, date: Date = .now, url: URL, text: String) {
        self.id = id
        self.user = user
        self.date = date
        self.url = url
        self.text = text
    }
}

extension Post {
    
    static let mocked = Post(id: "mock0",
                             user: .mocked,
                             url: URL(string: "https://www.theverge.com")!,
                             text: "The Verge Test")
}

extension Array where Element == Post {
    
    static let mocked: [Post] = [
        Post(id: "mock1",
             user: .mocked,
             url: URL(string: "https://google.com/")!,
             text: "Google Test"),
        Post(id: "mock2",
             user: .mocked,
             url: URL(string: "https://apple.com/")!,
             text: "Apple Test"),
        Post(id: "mock3",
             user: .mocked,
             url: URL(string: "https://nanameue.jp/")!,
             text: "Hello"),
    ]
}
