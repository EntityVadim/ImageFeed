//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest
import UIKit

final class ProfileViewControllerTests: XCTestCase {
    var presenter: ProfilePresenter!
    var presenterSpy: ProfilePresenterSpy!
    var viewController: ProfileViewController!
    
    override func setUp() {
        super.setUp()
        presenterSpy = ProfilePresenterSpy()
        presenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileImageService: ProfileImageService.shared
        )
        viewController = ProfileViewController()
        viewController.configure(presenter)
        presenter.view = viewController
        _ = viewController.view
    }
    
    override func tearDown() {
        presenter = nil
        viewController = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    func testViewDidLoadPresenterCalled() { // Не рабоатет
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testUpdateAvatarInvalidURL() {
        let invalidURL = URL(string: "invalid-url")!
        viewController.updateAvatar(with: invalidURL)
        XCTAssertNil(viewController.profileImageView.image)
    }
    
    func testLogoutButtonCallsPresenter() { // Не работает
        let logoutButton = viewController.logoutButton
        logoutButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(presenterSpy.didTapLogoutButtonCalled)
    }
    
    func testPresenterUpdatesProfileDetails() {
        let profileResult = ProfileResult(
            username: "testuser",
            firstName: "Test",
            lastName: "User",
            bio: "This is a test bio")
        let profile = Profile(result: profileResult)
        viewController.updateProfileDetails(profile: profile)
        XCTAssertEqual(viewController.nameLabel.text, profile.name)
        XCTAssertEqual(viewController.loginNameLabel.text, profile.loginName)
        XCTAssertEqual(viewController.descriptionLabel.text, profile.bio)
    }
    
    func testUpdateAvatarSetsImageView() {
        let url = URL(string: "https://api.unsplash.com/users/username")!
        viewController.updateAvatar(with: url)
        let expectation = self.expectation(description: "Image set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewController.profileImageView.image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testSetupUI() {
        XCTAssertTrue(viewController.view.subviews.contains(viewController.profileImageView))
        XCTAssertTrue(viewController.view.subviews.contains(viewController.logoutButton))
        XCTAssertTrue(viewController.view.subviews.contains(viewController.nameLabel))
        XCTAssertTrue(viewController.view.subviews.contains(viewController.loginNameLabel))
        XCTAssertTrue(viewController.view.subviews.contains(viewController.descriptionLabel))
        XCTAssertNotNil(viewController.profileImageView.constraints)
        XCTAssertNotNil(viewController.logoutButton.constraints)
        XCTAssertNotNil(viewController.nameLabel.constraints)
        XCTAssertNotNil(viewController.loginNameLabel.constraints)
        XCTAssertNotNil(viewController.descriptionLabel.constraints)
    }
}
