//
//  WebViewSpy.swift
//  ImageFeedTests
//
//  Created by Вадим on 16.07.2024.
//

import ImageFeed
import Foundation

// MARK: - WebViewPresenterSpy

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() { viewDidLoadCalled = true }
    func didUpdateProgressValue(_ newValue: Double) {}
    func code(from url: URL) -> String? { return nil }
}

// MARK: - WebViewViewControllerSpy

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) { loadRequestCalled = true }
    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}
