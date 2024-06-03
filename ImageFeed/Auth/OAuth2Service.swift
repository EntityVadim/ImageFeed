//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим on 03.06.2024.
//

import Foundation

// MARK: - OAuth2Service

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    // MARK: - Token Request
    
    func createTokenRequest(withCode code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let tokenURL = urlComponents.url else {
            fatalError("Invalid URL components.")
        }
        var tokenRequest = URLRequest(url: tokenURL)
        tokenRequest.httpMethod = "POST"
        tokenRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if let body = urlComponents.percentEncodedQuery?.data(using: .utf8) {
            tokenRequest.httpBody = body
        }
        return tokenRequest
    }
    
    func fetchOAuthToken(withCode code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let tokenRequest = createTokenRequest(withCode: code)
        let task = URLSession.shared.dataTask(with: tokenRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
        }
        task.resume()
    }
}
