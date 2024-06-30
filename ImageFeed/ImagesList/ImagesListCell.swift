//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим on 05.05.2024.
//

import UIKit
import Kingfisher

// MARK: - ImagesListCell

public final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Configure
    
    func configure(with photo: Photo) {
        let placeholder = UIImage(named: "stub")
        cellImage.kf.indicatorType = .activity
        let url = URL(string: photo.thumbImageURL)
        cellImage.kf.setImage(with: url)
        if photo.isLiked {
            likeButton.setImage(UIImage.likeButtonOn, for: .normal)
        } else {
            likeButton.setImage(UIImage.likeButtonOff, for: .normal)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
