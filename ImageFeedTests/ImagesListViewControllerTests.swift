//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    var viewController: ImagesListViewController!
    var presenterSpy: ImagesListPresenterSpy!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController
        presenterSpy = ImagesListPresenterSpy()
        viewController.configure(presenterSpy)
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    func testViewControllerCallsViewDidLoad() {
        _ = viewController.view
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testConfigureWithPresenter() {
        viewController.configure(presenterSpy)
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.presenter is ImagesListPresenterSpy)
        XCTAssertEqual(presenterSpy.view as? ImagesListViewController, viewController)
    }
    
    func testUpdateTableViewWithNewPhotos() {
        let newPhotos = [Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(), welcomeDescription: "Description",
            thumbImageURL: "thumbURL",
            fullImageUrl: "fullURL",
            isLiked: false)]
        viewController.updateTableView(with: newPhotos, animated: false)
        XCTAssertEqual(viewController.photos.count, 1)
        XCTAssertEqual(viewController.photos.first?.id, "1")
    }
}
