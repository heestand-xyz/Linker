//
//  MainContentService.swift
//  Linker
//
//  Created by Anton Heestand on 2022-08-01.
//

import Foundation
import Combine
import FirebaseFirestore
 
final class MainContentService: ContentService {
    
    var posts: [Post] = [] {
        didSet {
            postsSubject.value = posts
        }
    }
    
    lazy var postsSubject = CurrentValueSubject<[Post], Never>(posts)
    
    private let database: Firestore
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    init() {
        
        database = Firestore.firestore()
        
        Task {
            do {
                try await refresh()
            } catch {
                print("Content Error:", error)
            }
        }
    }
}

// MARK: - Service

extension MainContentService {
    
    enum ContentError: Error {
        case noDocumentReference
    }
    
    func refresh() async throws {
        
        let querySnapshot = try await database.collection("Post").getDocuments()
        
        var posts: [Post] = []
        for document in querySnapshot.documents {
            
            let id: String = document.documentID
            
            let data: [String: Any] = document.data()
            
            guard let userName: String = data["userName"] as? String else { continue }
            guard let userID: String = data["userID"] as? String else { continue }
            
            guard let dateString: String = data["date"] as? String else { continue }
            guard let date = dateFormatter.date(from: dateString) else { continue }
            
            guard let urlString: String = data["url"] as? String else { continue }
            guard let url: URL = URL(string: urlString) else { continue }
            
            guard let text: String = data["text"] as? String else { continue }
            
            let postUser = Post.User(name: userName, id: userID)
            let post = Post(id: id, user: postUser, date: date, url: url, text: text)
            
            posts.append(post)
        }
        
        self.posts = posts
    }
    
    func create(post: Post) async throws {
        
        let data: [String: Any] = [
            "userID": post.user.id,
            "userName": post.user.name,
            "date": dateFormatter.string(from: post.date),
            "text": post.text,
            "url": post.url.absoluteString,
        ]
        
        var documentReference: DocumentReference?
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
    
            documentReference = database.collection("Post").addDocument(data: data) { error in
                
                if let error: Error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume()
            }
        }
        
        guard let documentReference = documentReference else {
            throw ContentError.noDocumentReference
        }
        
        var post: Post = post
        post.id = documentReference.documentID
        
        posts.append(post)
    }
}
