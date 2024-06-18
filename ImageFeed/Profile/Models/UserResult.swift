//
//  File.swift
//  ImageFeed
//
//  Created by Вадим on 18.06.2024.
//

import Foundation

// MARK: - UserResult

struct UserResult: Codable {
    let profileImage: ProfileImageSize
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImageSize: Codable {
        let small: String
        let medium: String
        let large: String
    }
}
