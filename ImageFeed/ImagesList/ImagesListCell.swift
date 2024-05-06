import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    func configure(with imageName: String, date: String, isLiked: Bool) {
        cellImage.image = UIImage(named: imageName)
        dateLabel.text = date
        let likeImageName = isLiked ? "Like button" : "Don't like button"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }
}
