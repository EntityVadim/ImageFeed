//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

// MARK: - Profile ImageService

final class ProfileImageService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Helper Method
    
    private func createProfileImageURLRequest(
        username: String,
        token: String) -> URLRequest? {
            guard let profileImageURL = URL(string: "\(ProfileConstants.urlUsersPath)\(username)") else {
                print(NetworkError.invalidURL)
                return nil
            }
            var request = URLRequest(url: profileImageURL)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
    
    // MARK: - Fetch ProfileImage
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        task?.cancel()
        guard let request = createProfileImageURLRequest(username: username, token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknownError))
                }
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.emptyData))
                    }
                    return
                }
                do {
                    let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                    strongSelf.avatarURL = userResult.profileImage.large
                    DispatchQueue.main.async {
                        completion(.success(userResult.profileImage.large))
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: strongSelf,
                            userInfo: ["URL": userResult.profileImage.large])
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            default:
                let error = NetworkErrorHandler.handleErrorResponse(statusCode: httpResponse.statusCode)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}

// MARK: - Clear ProfileImage

extension ProfileImageService {
    func clearProfileImage() {
        avatarURL = nil
    }
}
