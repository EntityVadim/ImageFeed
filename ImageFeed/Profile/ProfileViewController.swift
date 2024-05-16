//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим on 16.05.2024.
//

import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction private func didTapLogoutButton() {
    }
}
