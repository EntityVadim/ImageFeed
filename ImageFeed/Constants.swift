//
//  Constants.swift
//  ImageFeed
//
//  Created by Вадим on 30.05.2024.
//

import Foundation

// MARK: - Constants

enum Constants {
    static let accessKey = "tpqQ4kdh8YgkwkT5RlJsjsJy3SxN4hOXgDxPLuIbu9w"
    static let secretKey = "uCl2U73o38AZn1byh83IqlX8YLM01YNRapTcsknD44c"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let urlComponentsURLString = "https://unsplash.com/oauth/token"
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlComponentsPath = "/oauth/authorize/native"
}

enum OAuthConstants {
    static let baseURL = "https://unsplash.com"
}
