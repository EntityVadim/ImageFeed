//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим on 14.06.2024.
//

import UIKit

// MARK: - Profile Service

final class ProfileService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Helper Method
    
    private func createProfileURLRequest(token: String) -> URLRequest? {
        guard let profileURL = URL(string: ProfileConstants.urlProfilePath) else {
            print(NetworkError.invalidURL)
            return nil
        }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    // MARK: - Fetch Profile
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<(Profile, String), Error>) -> Void
    ) {
        task?.cancel()
        guard let request = createProfileURLRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
            }
            guard let self = self else { return }
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
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = Profile(result: profileResult)
                    self.profile = profile
                    DispatchQueue.main.async {
                        completion(.success((profile, profileResult.username)))
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

// MARK: - Clear Profile

extension ProfileService {
    func clearProfile() {
        profile = nil
    }
}
