//
//  UserResult.swift
//  ImageFeed
//
//  Created by Вадим on 18.06.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageSize
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImageSize: Codable {
        let large: String
    }
}
