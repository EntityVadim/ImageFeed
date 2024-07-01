//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Вадим on 27.06.2024.
//

import UIKit
import Kingfisher

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isLoading: Bool = false
    private var storage = OAuth2TokenStorage.shared
    
    let dateFormatter = ISO8601DateFormatter()
    
    private func createPhotoRequest(page: Int, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos?page=\(page)&per_page=10") else
        { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = storage.token, let request = createPhotoRequest(page: nextPage, token: token) else {
            isLoading = false
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            do {
                let photoResult = try JSONDecoder().decode([PhotoResult].self, from: data)
                DispatchQueue.main.async {
                    self.preparePhoto(photoResult: photoResult)
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
    
    private func preparePhoto(photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height),
                createdAt: dateFormatter.date(from: item.createdAt!),
                welcomeDescription: item.description,
                thumbImageURL: item.urls.thumb,
                largeImageURL: item.urls.full,
                isLiked: item.isLiked)
        }
        photos.append(contentsOf: newPhotos)
    }
    
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = storage.token else {
            completion(.failure(NetworkError.authorizationError))
            return
        }
        let urlString = "\(Constants.defaultBaseURL)/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLiked ? "DELETE" : "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                self.updatePhotoLikeStatus(photoId: photoId, isLiked: isLiked)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            default:
                let error = NetworkErrorHandler.handleErrorResponse(statusCode: httpResponse.statusCode)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func updatePhotoLikeStatus(photoId: String, isLiked: Bool) {
        DispatchQueue.main.async {
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.photos[index]
                let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !isLiked
                )
                self.photos[index] = newPhoto
                NotificationCenter.default.post(
                    name: .didChangePhotoLikeStatus,
                    object: self,
                    userInfo: ["photo": newPhoto]
                )
            } else {
                print("Фотография с ID \(photoId) не найдена.")
            }
        }
    }
}

extension Notification.Name {
    static let didChangePhotoLikeStatus = Notification.Name("didChangePhotoLikeStatus")
}

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) {
        guard index >= 0 && index < count else { return }
        self[index] = newValue
    }
}
