//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Вадим on 27.06.2024.
//

import Foundation


// MARK: - PhotoResult

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
}

// MARK: - UrlsResult

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}