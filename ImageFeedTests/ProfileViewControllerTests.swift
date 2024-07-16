//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileService()
        let profileImageService = ProfileImageService()
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService)
        viewController.configure(presenter)
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileService()
        let profileImageService = ProfileImageService()
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService)
        viewController.configure(presenter)
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
