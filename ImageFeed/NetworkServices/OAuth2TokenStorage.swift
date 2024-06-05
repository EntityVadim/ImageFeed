//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим on 03.06.2024.
//

import Foundation

// MARK: - OAuth2TokenStorage

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2Token"
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    var isTokenValid: Bool {
        if let tokenCreationTime = UserDefaults.standard.object(forKey: "TokenCreationTimeKey") as? TimeInterval {
            return (Date().timeIntervalSince1970 - tokenCreationTime) < 3600
        }
        return false
    }
}
