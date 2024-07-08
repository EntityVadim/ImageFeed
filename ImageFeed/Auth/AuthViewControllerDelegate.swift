//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Вадим on 17.06.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
    func fetchProfile(_ token: String)
}
