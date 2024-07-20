//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Вадим on 01.07.2024.
//

import Foundation
import WebKit

// MARK: - Profile LogoutService

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileLogoutService()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func logout() {
        cleanCookies()
        clearLocalData()
        switchToSplashViewController()
    }
    
    // MARK: - Private Methods
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes())
        { records in records.forEach
            { record in WKWebsiteDataStore.default().removeData(
                ofTypes: record.dataTypes,
                for: [record],
                completionHandler: {})
            }
        }
    }
    
    private func clearLocalData() {
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearProfileImage()
        ImagesListService.shared.clearImagesList()
        OAuth2TokenStorage.shared.logout()
    }
    
    private func switchToSplashViewController() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                assertionFailure("Не удалось получить windowScene или window")
                return
            }
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
            window.makeKeyAndVisible()
        }
    }
}
