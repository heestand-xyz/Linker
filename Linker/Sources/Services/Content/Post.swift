//
//  Post.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation

struct Post: Identifiable {
    
    let userID: String

    let date: Date
    var id: Date {
        date
    }
    
    let url: URL
    let text: String
}

extension Post {
    
    static let mocked = Post(userID: "test",
                             date: .now,
                             url: URL(string: "https://google.com/")!,
                             text: "Test")
}
