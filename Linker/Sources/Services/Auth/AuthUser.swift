//
//  User.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-28.
//

import UIKit
import FirebaseAuth

struct AuthUser {
    
    var name: String?
    var email: String
    var photo: UIImage?
}

extension AuthUser {
    
    init(user: User) async throws {
        name = user.displayName
        email = user.email ?? ""
        if let url = user.photoURL {
            photo = try? await AuthUser.downloadPhoto(url: url)
        }
    }
}

extension AuthUser {
    
    enum DownloadError: Error {
        case badStatus(Int)
        case badImage
    }
    
    static func downloadPhoto(url: URL) async throws -> UIImage {
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                throw DownloadError.badStatus(httpResponse.statusCode)
            }
        }
        
        guard let image = UIImage(data: data) else {
            throw DownloadError.badImage
        }
        
        return image
    }
}
