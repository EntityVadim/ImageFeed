//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import UIKit

// MARK: - WebViewViewControllerDelegate

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
