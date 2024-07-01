//
//  File.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

// MARK: - OAuth2TokenStorageProtocol

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}
