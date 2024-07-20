//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    var sut: ImagesListViewController!
    var presenter: ImagesListPresenterSpy!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        presenter = ImagesListPresenterSpy()
        sut.configure(presenter)
        presenter.view = sut
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
//    func testDidSelectRowAt() {
//        let indexPath = IndexPath(row: 0, section: 0)
//        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
//        XCTAssertTrue(presenter.didSelectRowAtCalled)
//    }
//    
//    func testWillDisplayCell() {
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = UITableViewCell()
//        sut.tableView(sut.tableView, willDisplay: cell, forRowAt: indexPath)
//        XCTAssertTrue(presenter.willDisplayCellCalled)
//    }
    
    func testDidTapLikeButton() {
        let cell = ImagesListCell()
        sut.imageListCellDidTapLike(cell)
        XCTAssertTrue(presenter.didTapLikeButtonCalled)
    }
    
    func testUpdateTableView() {
        let mockView = ImagesListViewControllerSpy()
        sut.configure(presenter)
        presenter.view = mockView
        let photos = [Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            fullImageUrl: "",
            isLiked: false)]
        sut.updateTableView(with: photos, animated: false)
        XCTAssertTrue(mockView.updateTableViewCalled)
    }
    
    func testNavigateToImageController() {
        let mockView = ImagesListViewControllerSpy()
        sut.configure(presenter)
        presenter.view = mockView
        sut.navigateToImageController(with: "https://example.com/image.jpg")
        XCTAssertTrue(mockView.navigateToImageControllerCalled)
    }
    
    func testUpdateLikeButton() {
        let mockView = ImagesListViewControllerSpy()
        sut.configure(presenter)
        presenter.view = mockView
        let indexPath = IndexPath(row: 0, section: 0)
        sut.updateLikeButton(at: indexPath, isLiked: true)
        XCTAssertTrue(mockView.updateLikeButtonCalled)
    }
    
//    func testCellForRowAt() {
//        let tableView = sut.tableView
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? ImagesListCell
//        XCTAssertNotNil(cell)
//        XCTAssertEqual(cell?.reuseIdentifier, ImagesListCell.reuseIdentifier)
//    }
    
//    func testHeightForRowAt() {
//        let indexPath = IndexPath(row: 0, section: 0)
//        let height = sut.tableView(sut.tableView, heightForRowAt: indexPath)
//        XCTAssertGreaterThan(height, 0)
//    }
}
