//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Вадим on 03.06.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
