//
//  ContentServiceManager.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import Foundation
import Combine

final class ContentServiceManager: ObservableObject, ContentService {
    
    @Published var posts: [Post] = []
    
    var postsSubject: CurrentValueSubject<[Post], Never> {
        service.postsSubject
    }
    
    private let service: ContentService
    
    init(service: ContentService) {
        
        self.service = service
        
        setup()
    }
}

// MARK: - Setup

extension ContentServiceManager {
    
    private func setup() {
        
        posts = service.posts
        
        service.postsSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$posts)
    }
}

// MARK: - Service

extension ContentServiceManager {
    
    func refresh() async throws {
        try await service.refresh()
    }
    
    func create(post: Post) async throws {
        try await service.create(post: post)
    }
}

// MARK: - Mock

extension ContentServiceManager {
    static let mocked = ContentServiceManager(service: MockedContentService())
}
