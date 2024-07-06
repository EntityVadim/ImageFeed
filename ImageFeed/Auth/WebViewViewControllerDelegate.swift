//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
