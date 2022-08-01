//
//  ContentService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation
import Combine

protocol ContentService {
    
    var posts: [Post] { get set }
    var postsSubject: CurrentValueSubject<[Post], Never> { get }
    
    func refresh() async throws
    func create(post: Post) async throws
    func delete(post: Post) async throws
}
