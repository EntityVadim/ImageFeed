//
//  NetworkErrorProtocol.swift
//  ImageFeed
//
//  Created by Вадим on 06.07.2024.
//

import Foundation

protocol NetworkErrorProtocol {
    static func errorMessage(from error: Error) -> String
}
