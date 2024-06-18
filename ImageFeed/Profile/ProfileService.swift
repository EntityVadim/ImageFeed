//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим on 14.06.2024.
//

import UIKit

// MARK: - ProfileService

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    // MARK: - Private Properties
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Helper Method
    
    private func createProfileURLRequest(token: String) -> URLRequest {
        guard let profileURL = URL(string: ProfileConstants.urlProfilePath) else {
            fatalError("Неверный URL профиля.")
        }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - FetchProfile
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) {
        task?.cancel()
        let request = createProfileURLRequest(token: token)
        task = URLSession.shared.objectTask(for: request, with: ProfileResult.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.profile = profile
                DispatchQueue.main.async {
                    completion(.success(profileResult))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}

//    func fetchProfile(
//        _ token: String,
//        completion: @escaping (Result<(Profile, String), Error>) -> Void
//    ) {
//        task?.cancel()
//        let request = createProfileURLRequest(token: token)
//        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let self = self else { return }
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//                DispatchQueue.main.async {
//                    completion(.failure(NSError(
//                        domain: "",
//                        code: statusCode,
//                        userInfo: [NSLocalizedDescriptionKey: "Ошибка сети или сервера с кодом \(statusCode)."])))
//                }
//                return
//            }
//            do {
//                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
//                let profile = Profile(result: profileResult)
//                self.profile = profile
//                DispatchQueue.main.async {
//                    completion(.success((profile, profileResult.username)))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//        task?.resume()
//    }
//}
