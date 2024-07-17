//
//  ImagesListSpy.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

import ImageFeed
import Foundation

// MARK: - ImagesListPresenterSpy

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var fetchPhotosNextPageCalled = false
    
    func viewDidLoad() { viewDidLoadCalled = true }
    func didSelectRowAt(indexPath: IndexPath) {}
    func willDisplayCell(at indexPath: IndexPath) { fetchPhotosNextPageCalled = true }
    func didTapLikeButton(at indexPath: IndexPath) {}
}

// MARK: - ImagesListViewControllerSpy

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewCalled = false
    var navigateToImageController = false
    var updateLikeButtonCalled = false
    
    func updateTableView(with newPhotos: [Photo], animated: Bool) { updateTableViewCalled = true }
    func navigateToImageController(with url: String) { navigateToImageController = true }
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool) { updateLikeButtonCalled = true }
}
