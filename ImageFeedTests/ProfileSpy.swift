//
//  ProfileSpy.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

import ImageFeed
import Foundation
import UIKit

// MARK: - ProfilePresenterSpy

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var updateAvatarCalled = false

    func viewDidLoad() { viewDidLoadCalled = true }
    func didTapLogoutButton() { didTapLogoutButtonCalled = true }
    func updateAvatar(with url: URL) { updateAvatarCalled = true }
}

// MARK: - ProfileViewControllerSpy

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var presenter: ProfilePresenterProtocol?

    func updateProfileDetails(profile: Profile?) { updateProfileDetailsCalled = true }
    func updateAvatar(with url: URL) { updateAvatarCalled = true }
}
