//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Вадим on 15.07.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
