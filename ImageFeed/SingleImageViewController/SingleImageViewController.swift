//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Вадим on 17.05.2024.
//

import UIKit

// MARK: - SingleImageViewController

final class SingleImageViewController: UIViewController{
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
