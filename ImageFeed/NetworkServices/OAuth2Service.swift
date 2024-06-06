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
    
    init() {}
    
    // MARK: - Token Request
    
    private func createTokenRequest(withCode code: String) -> URLRequest {
        var urlComponents = URLComponents(string: Constants.urlComponentsURLString)!
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
        return tokenRequest
    }
}

// MARK: - ErrorProcessing

extension OAuth2Service {
    func fetchOAuthToken(withCode code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let tokenRequest = createTokenRequest(withCode: code)
        let task = URLSession.shared.dataTask(with: tokenRequest) { data, response, error in
            if let error = error {
                print("Сетевая ошибка: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Не удалось получить HTTP-ответ.")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить HTTP-ответ."])))
                return
            }
            switch httpResponse.statusCode {
            case 200:
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data!)
                    OAuth2TokenStorage.shared.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case 400:
                print("Неверный запрос: возможно, отсутствует необходимый параметр.")
            case 401:
                print("Ошибка авторизации: неверный токен доступа.")
            case 403:
                print("Доступ запрещен: отсутствуют разрешения для выполнения запроса.")
            case 404:
                print("Ресурс не найден.")
            case 500, 503:
                print("Ошибка на сервере.")
            default:
                print("Неизвестная ошибка с кодом \(httpResponse.statusCode).")
            }
            if httpResponse.statusCode != 200 {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let dictionary = json as? [String: Any],
                   let errors = dictionary["errors"] as? [String] {
                    for errorMessage in errors {
                        print("Ошибка: \(errorMessage)")
                    }
                }
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка с кодом \(httpResponse.statusCode)."])))
            }
        }
        task.resume()
    }
}
