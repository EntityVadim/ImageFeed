//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим on 14.06.2024.
//

import UIKit

// MARK: - ProfileService

final class ProfileService {
    
    private var task: URLSessionDataTask?
    
    static let shared = ProfileService()
    
    // MARK: - Helper Method
    
    private func createURLRequest(token: String) -> URLRequest {
        guard let profileURL = URL(string: ProfileConstants.urlProfilePath) else {
            fatalError("Неверный URL профиля.")
        }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - Public Methods
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        task?.cancel()
        let request = createURLRequest(token: token)
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard self != nil else { return }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                DispatchQueue.main.async {
                    completion(.failure(NSError(
                        domain: "",
                        code: statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Ошибка сети или сервера с кодом \(statusCode)."])))
                }
                return
            }
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(result: profileResult)
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}
