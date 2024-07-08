//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим on 05.05.2024.
//

import Kingfisher
import UIKit

// MARK: - ImagesList Cell

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Private Properties
    
    private let imagesListServise = ImagesListService.shared
    
    // MARK: - Public Methods
    
    func configure(with photo: Photo) {
        let placeholder = UIImage(named: "stub")
        cellImage.kf.indicatorType = .activity
        let url = URL(string: photo.thumbImageURL)
        cellImage.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.1)),
                .cacheOriginalImage])
        if photo.isLiked {
            likeButton.setImage(UIImage.likeButtonOn, for: .normal)
        } else {
            likeButton.setImage(UIImage.likeButtonOff, for: .normal)
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func updateDateLabel(withText text: String) {
        dateLabel.text = text
    }
    
    // MARK: - IBAction
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
