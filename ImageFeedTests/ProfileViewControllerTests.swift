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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ProfileViewController") as! ProfileViewController
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.configure(presenter)
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.configure(presenter)
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
