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
    var didSelectRowAtCalled = false
    var willDisplayCellCalled = false
    var didTapLikeButtonCalled = false
    
    func viewDidLoad() { viewDidLoadCalled = true }
    func didSelectRowAt(indexPath: IndexPath) { didSelectRowAtCalled = true }
    func willDisplayCell(at indexPath: IndexPath) { willDisplayCellCalled = true }
    func didTapLikeButton(at indexPath: IndexPath) { didTapLikeButtonCalled = true }
}

// MARK: - ImagesListViewControllerSpy

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewCalled = false
    var navigateToImageControllerCalled = false
    var updateLikeButtonCalled = false
    
    var newPhotos: [Photo] = []
    var animated: Bool = false
    var url: String?
    var indexPath: IndexPath?
    var isLiked: Bool?
    
    func updateTableView(with newPhotos: [Photo], animated: Bool) {
        updateTableViewCalled = true
        self.newPhotos = newPhotos
        self.animated = animated
    }
    
    func navigateToImageController(with url: String) {
        navigateToImageControllerCalled = true
        self.url = url
    }
    
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool) {
        updateLikeButtonCalled = true
        self.indexPath = indexPath
        self.isLiked = isLiked
    }
}
