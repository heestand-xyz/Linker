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
}
