//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Вадим on 16.07.2024.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    
    init(profileService: ProfileService = .shared, profileImageService: ProfileImageService = .shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
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
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        view?.updateAvatar(with: url)
    }
    
    func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
}
