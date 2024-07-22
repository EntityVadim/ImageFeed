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
    var viewControllerSpy: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController
        presenterSpy = ImagesListPresenterSpy()
        viewControllerSpy = ImagesListViewControllerSpy()
        presenterSpy.view = viewControllerSpy
        viewController.configure(presenterSpy)
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        viewControllerSpy = nil
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
    
    func testNavigateToImageController() {
        viewControllerSpy.navigateToImageController(
            with: "https://api.unsplash.com/photos?page=/page&per_page=10")
        presenterSpy.didSelectRowAt(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertTrue(viewControllerSpy.navigateToImageControllerCalled)
    }
}
