//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Вадим on 17.05.2024.
//

import UIKit

// MARK: - SingleImageViewController

final class SingleImageViewController: UIViewController{
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
