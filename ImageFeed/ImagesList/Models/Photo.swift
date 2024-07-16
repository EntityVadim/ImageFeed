//
//  Photo.swift
//  ImageFeed
//
//  Created by Вадим on 27.06.2024.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageUrl: String
    let isLiked: Bool
}
