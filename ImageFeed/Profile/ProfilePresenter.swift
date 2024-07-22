//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Вадим on 16.07.2024.
//

import Kingfisher
import Foundation

// MARK: - Profile Presenter

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    
    // MARK: - Initializers
    
    init(profileService: ProfileService = .shared, profileImageService: ProfileImageService = .shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
        updateAvatar()
    }
    
    func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
    
    // MARK: - Private Methods
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        view?.updateAvatar(with: url)
    }
}
