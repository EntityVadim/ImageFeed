//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Вадим on 04.05.2024.
//

import UIKit

// MARK: - ImagesList ViewController

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let storage = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private var isLoadingNewPage = false
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        setupTableView()
        subscribeToNotifications()
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - PrepareImagesList
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Недопустимый пункт назначения перехода.")
                return
            }
            let photo = photos[indexPath.row]
            viewController.fullImageUrl = photo.fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivePhotosUpdate),
            name: ImagesListService.didChangeNotification,
            object: nil)
    }
    
    private func updateTableViewAnimated(
        with newPhotos: [Photo],
        animated: Bool
    ) {
        let oldCount = photos.count
        let newCount = newPhotos.count
        let diff = newCount - oldCount
        photos = newPhotos
        if animated {
            tableView.performBatchUpdates {
                if diff > 0 {
                    let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } else if diff < 0 {
                    let indexPaths = (newCount..<oldCount).map { IndexPath(row: $0, section: 0) }
                    tableView.deleteRows(at: indexPaths, with: .automatic)
                }
            } completion: { _ in
                if diff != 0 {
                    self.tableView.reloadData()
                }
            }
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: - Notifications
    
    @objc private func didReceivePhotosUpdate(notification: Notification) {
        guard let newPhotos = notification.userInfo?["photos"] as? [Photo] else { return }
        updateTableViewAnimated(with: newPhotos, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
            let image = photos[indexPath.row]
            let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let imageWidth = image.size.width
            let scale = imageViewWidth / imageWidth
            let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
            return cellHeight
        }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return photos.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath) as? ImagesListCell else {
                print("Неправильная ячейка!")
                return UITableViewCell()
            }
            let photo = photos[indexPath.row]
            if let createdAt = photo.createdAt {
                cell.updateDateLabel(withText: dateFormatter.string(from: createdAt))
            } else {
                cell.updateDateLabel(withText: "Дата неизвестна")
            }
            cell.configure(with: photo)
            cell.delegate = self
            return cell
        }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photos = self.imagesListService.photos
                cell.setIsLiked(!photo.isLiked)
            case .failure(let error):
                print("Не удалось поставить лайк: \(error)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
