//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим on 15.07.2024.
//

import Foundation

// MARK: - WebView Presenter

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            assertionFailure("Failed to construct authorization URLRequest")
            return
        }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
