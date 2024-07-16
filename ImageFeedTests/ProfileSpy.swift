//
//  ProfileSpy.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?

    func viewDidLoad() { viewDidLoadCalled = true }
    func didTapLogoutButton() { }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var updateProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var presenter: ProfilePresenterProtocol?

    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    func updateProfileDetails(profile: Profile?) { updateProfileDetailsCalled = true }
    func updateAvatar(with url: URL) { updateAvatarCalled = true }
}
