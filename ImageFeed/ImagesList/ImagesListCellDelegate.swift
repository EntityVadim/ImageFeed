//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Вадим on 01.07.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
