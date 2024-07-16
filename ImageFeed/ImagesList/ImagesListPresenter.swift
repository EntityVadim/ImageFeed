//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Вадим on 16.07.2024.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService: ImagesListService
    
    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let newPhotos = notification.userInfo?["photos"] as? [Photo] else { return }
            self?.view?.updateTableView(with: newPhotos, animated: true)
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        view?.navigateToSingleImageViewController(with: photo.fullImageUrl)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLikeButton(at indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.view?.updateLikeButton(at: indexPath, isLiked: !photo.isLiked)
            case .failure(let error):
                print("Не удалось поставить лайк: \(error)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
