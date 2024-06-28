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
                print(photoResult)
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
            task.resume()
    }
    
    func preparePhoto(photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height),
                createdAt: dateFormatter.date(from: item.createdAt!),
                welcomeDescription: item.description,
                thumbImageURL: item.urls.thumb,
                largeImageURL: item.urls.full,
                isLiked: item.likedByUser)
        }
        photos.append(contentsOf: newPhotos)
    }
}
