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
    
    // MARK: - Private Properties
    
    private var currentAuthCode: String?
    private var currentTask: URLSessionDataTask?
    
    // MARK: - CancelPreviousTaskIfNecessary
    
    func cancelPreviousTaskIfNecessary(forNewAuthCode newAuthCode: String) {
        if let currentAuthCode = currentAuthCode, currentAuthCode == newAuthCode {
            currentTask?.cancel()
        }
        self.currentAuthCode = newAuthCode
    }
}

// MARK: - Token Request

private extension OAuth2Service {
    func createTokenRequest(withCode code: String) -> URLRequest {
        var urlComponents = URLComponents(string: Constants.urlComponentsURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let tokenURL = urlComponents.url else {
            fatalError(NetworkErrorHandler.errorMessage(from: NetworkErrorHandler.handleInvalidURLComponents()))
        }
        var tokenRequest = URLRequest(url: tokenURL)
        tokenRequest.httpMethod = "POST"
        return tokenRequest
    }
}

// MARK: - ErrorProcessing

extension OAuth2Service {
    func fetchOAuthToken(
        withCode code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let tokenRequest = createTokenRequest(withCode: code)
        currentTask = URLSession.shared.objectTask(for: tokenRequest, with: OAuthTokenResponseBody.self) { result in
            switch result {
            case .success(let responseBody):
                OAuth2TokenStorage.shared.token = responseBody.accessToken
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
}

//extension OAuth2Service {
//    func fetchOAuthToken(
//        withCode code: String,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        let tokenRequest = createTokenRequest(withCode: code)
//        let task = URLSession.shared.dataTask(with: tokenRequest) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                  let data = data else {
//                DispatchQueue.main.async {
//                    completion(.failure(NetworkError.unknownError))
//                }
//                return
//            }
//            switch httpResponse.statusCode {
//            case 200:
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                    DispatchQueue.main.async {
//                        OAuth2TokenStorage.shared.token = responseBody.accessToken
//                        completion(.success(responseBody.accessToken))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            default:
//                let error = NetworkErrorHandler.handleErrorResponse(statusCode: httpResponse.statusCode)
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//        task.resume()
//    }
//}
