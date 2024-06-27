//
//  Photo.swift
//  ImageFeed
//
//  Created by Вадим on 27.06.2024.
//

import Foundation

// MARK: - Photo

struct Photo: Decodable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
