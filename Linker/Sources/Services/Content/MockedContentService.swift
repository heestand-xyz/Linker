//
//  MockedContentService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation
import Combine

final class MockedContentService: ContentService {
    
    var posts: [Post] = .mocked {
        didSet {
            postsSubject.value = posts
        }
    }
    
    lazy var postsSubject = CurrentValueSubject<[Post], Never>(posts)
    
    func refresh() async throws {
        
        await delay()
        
        posts = [.mocked]
    }
    
    func create(post: Post) async throws {
        
        await delay()
        
        posts.append(post)
    }
    
    private func delay() async {
        
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                continuation.resume()
            }
        }
    }
}
