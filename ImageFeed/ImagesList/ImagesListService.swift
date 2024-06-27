//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Вадим on 27.06.2024.
//

import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
    }
}
