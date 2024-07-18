//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotosNextPage() {
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewController()
        viewController.configure(presenter)
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testUpdateTableView() {
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewController()
        viewController.configure(presenter)
        presenter.view = viewController
        let photos = [Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "",
            fullImageUrl: "",
            isLiked: false)]
        viewController.updateTableView(with: photos, animated: false)
        //XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), photos.count)
    }
}
