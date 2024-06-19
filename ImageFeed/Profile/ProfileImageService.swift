//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

// MARK: - ProfileImageService

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    // MARK: - Private Properties
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Helper Method
    
    private func createProfileImageURLRequest(
        username: String,
        token: String) -> URLRequest {
            guard let profileImageURL = URL(string: "\(Constants.defaultBaseURL)/users/\(username)/photos") else {
                fatalError("Неверный URL пользователя.")
            }
            var request = URLRequest(url: profileImageURL)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
    
    // MARK: - FetchProfileImageURL
    
    //    func fetchProfileImageURL(
    //        username: String,
    //        token: String,
    //        completion: @escaping (Result<String, Error>) -> Void
    //    ) {
    //        task?.cancel()
    //
    //        let request = createProfileImageURLRequest(username: username, token: token)
    //        task = URLSession.shared.objectTask(for: request, completion: { (result: Result<UserResult, Error>) in
    //            switch result {
    //            case .success(let userResult):
    //                self.avatarURL = userResult.profileImage.small
    //                NotificationCenter.default.post(
    //                    name: ProfileImageService.didChangeNotification,
    //                    object: self,
    //                    userInfo: ["URL": userResult.profileImage.small])
    //                completion(.success(userResult.profileImage.small))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        })
    //    }
    //}
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        task?.cancel()
        let request = createProfileImageURLRequest(username: username, token: token)
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
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
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                strongSelf.avatarURL = userResult.profileImage.small
                DispatchQueue.main.async {
                    completion(.success(userResult.profileImage.small))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: strongSelf,
                        userInfo: ["URL": userResult.profileImage.small])
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
