//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим on 14.06.2024.
//

import UIKit

// MARK: - ProfileService

final class ProfileService {
    
    private var lastCode: String?
    private var task: URLSessionDataTask?
    
    // MARK: - ProfileResult
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    // MARK: - Profile
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
        
        init(result: ProfileResult) {
            self.username = result.username
            self.name = "\(result.firstName ?? "") \(result.lastName ?? "")"
            self.loginName = "@\(result.username)"
            self.bio = result.bio
        }
    }
    
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
    
//    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
//            if lastCode == token { return }
//            task?.cancel()
//            lastCode = token
//            OAuth2Service.shared.fetchOAuthToken(withCode: token) { [weak self] result in
//                switch result {
//                case .success(let accessToken):
//                    self?.performProfileRequest(withAccessToken: accessToken, completion: completion)
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
}
