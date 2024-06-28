//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим on 05.05.2024.
//

import UIKit
import Kingfisher

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Configure
    
    func configure(with photo: Photo) {
        let placeholder = UIImage(named: "stub")
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: placeholder,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    //    func configure(with imageName: String, date: String, isLiked: Bool) {
    //        cellImage.image = UIImage(named: imageName)
    //        dateLabel.text = date
    //        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
    //        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    //    }
}
