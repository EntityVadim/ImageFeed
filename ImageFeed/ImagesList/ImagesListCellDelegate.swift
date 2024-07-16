//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Вадим on 01.07.2024.
//

import Foundation

// MARK: - ImagesListCellDelegate

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImagesListPresenterProtocol

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func didSelectRowAt(indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func didTapLikeButton(at indexPath: IndexPath)
}

// MARK: - ImagesListViewControllerProtocol

public protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableView(with newPhotos: [Photo], animated: Bool)
    func navigateToImageController(with url: String)
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool)
}
