//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Вадим on 04.05.2024.
//

import UIKit

// MARK: - ImagesListViewController

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let storage = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    //private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        setupTableView()
        subscribeToNotifications()
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImagesListCell", bundle: nil), forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePhotosUpdate), name: ImagesListService.didChangeNotification, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc private func didReceivePhotosUpdate(notification: Notification) {
        guard let photos = notification.userInfo?["photos"] as? [Photo] else { return }
        self.photos = photos
        //tableView.performBatchUpdates(nil)
    }
    
    // MARK: - Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Недопустимый пункт назначения перехода.")
                return
            }
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
            viewController.largeImageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
//        func tableView(
//            _ tableView: UITableView,
//            willDisplay cell: UITableViewCell,
//            forRowAt indexPath: IndexPath
//        ) {
//            //let photos = imagesListService.photos
//            if indexPath.row + 1 == photos.count {
//                imagesListService.fetchPhotosNextPage()
//            }
//        }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1 {
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
                return UITableViewCell()
            }
            //let imageName = photos[indexPath.row]
            //let dateText = dateFormatter.string(from: Date())
            //let isLiked = indexPath.row % 2 == 0
            //cell.configure(with: imageName, date: dateText, isLiked: isLiked)
            let photo = photos[indexPath.row]
            cell.configure(with: photo)
            return cell
        }
}
