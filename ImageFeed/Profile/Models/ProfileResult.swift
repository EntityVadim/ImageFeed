//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

struct Profile: Decodable {
    let username: String
    let name: String?
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.firstName ?? "") \(result.lastName ?? "")"
        self.loginName = "@\(result.username)"
        self.bio = result.bio
    }
}

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
