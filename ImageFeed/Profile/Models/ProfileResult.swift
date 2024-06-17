//
//  Profille11.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

// MARK: - ProfileResult

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
