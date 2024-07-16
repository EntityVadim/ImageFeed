//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Вадим on 16.07.2024.
//

import Foundation

// MARK: - ProfilePresenterProtocol

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
}

// MARK: - ProfileViewControllerProtocol

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile?)
    func updateAvatar(with url: URL)
}
