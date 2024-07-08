//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим on 03.06.2024.
//

import SwiftKeychainWrapper
import UIKit

// MARK: - OAuth2 TokenStorage

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return keyChain.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                keyChain.set(token, forKey: Keys.token.rawValue)
            } else {
                keyChain.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let keyChain = KeychainWrapper.standard
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func logout() {
        keyChain.removeObject(forKey: Keys.token.rawValue)
    }
    
    // MARK: - Private Methods
    
    private enum Keys: String {
        case token
    }
}
