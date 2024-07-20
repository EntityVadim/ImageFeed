//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    
    var sut: ImagesListViewController!
    var presenterSpy: ImagesListPresenterSpy!
    var viewControllerSpy: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        sut = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "ImagesListViewController") as? ImagesListViewController
        presenterSpy = ImagesListPresenterSpy()
        viewControllerSpy = ImagesListViewControllerSpy()
        sut.configure(presenterSpy)
    }
    
    func test_viewDidLoad_callsPresenterViewDidLoad() {
        sut.viewDidLoad()
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func test_tableView_didSelectRowAt_callsPresenterDidSelectRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(presenterSpy.didSelectRowAtCalled)
    }
    
    func test_tableView_willDisplayCell_callsPresenterWillDisplayCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)
        XCTAssertTrue(presenterSpy.willDisplayCellCalled)
    }
    
    func test_updateTableView_updatesTableViewWithNewPhotos() {
        let photos = [Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: nil, welcomeDescription: nil, thumbImageURL: "url", fullImageUrl: "fullUrl", isLiked: false)]
        sut.updateTableView(with: photos, animated: true)
        XCTAssertTrue(viewControllerSpy.updateTableViewCalled)
        XCTAssertEqual(viewControllerSpy.newPhotos, photos)
        XCTAssertTrue(viewControllerSpy.animated)
    }
    
    func test_navigateToImageController_callsPerformSegueWithIdentifier() {
        let url = "http://example.com"
        sut.navigateToImageController(with: url)
        XCTAssertTrue(viewControllerSpy.navigateToImageControllerCalled)
        XCTAssertEqual(viewControllerSpy.url, url)
    }
    
    func test_updateLikeButton_updatesLikeButton() {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.updateLikeButton(at: indexPath, isLiked: true)
        XCTAssertTrue(viewControllerSpy.updateLikeButtonCalled)
        XCTAssertEqual(viewControllerSpy.indexPath, indexPath)
        XCTAssertTrue(viewControllerSpy.isLiked ?? false)
    }
}
