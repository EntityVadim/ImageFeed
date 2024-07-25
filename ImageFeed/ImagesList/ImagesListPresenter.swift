//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Вадим on 16.07.2024.
//

import Foundation

// MARK: - ImagesList Presenter

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let imagesListService: ImagesListService
    
    // MARK: - Initializers
    
    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self, let newPhotos = notification.userInfo?["photos"] as? [Photo] else {
                return
            }
            self.handleNewPhotos(newPhotos)
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        view?.navigateToImageController(with: photo.fullImageUrl)
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
    
    // MARK: - Private Methods
    
    private func handleNewPhotos(_ newPhotos: [Photo]) {
        let oldCount = imagesListService.photos.count - newPhotos.count
        let newCount = imagesListService.photos.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        if let viewController = view as? ImagesListViewController {
            viewController.photos.append(contentsOf: newPhotos)
            viewController.updateTableView(with: indexPaths, animated: true)
        }
    }
}
