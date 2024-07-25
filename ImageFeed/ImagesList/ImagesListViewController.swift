//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Вадим on 04.05.2024.
//

import UIKit

// MARK: - ImagesList ViewController

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var photos: [Photo] = []
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    // MARK: - Private Properties
    
    private var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - PrepareImagesList
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let fullImageUrl = sender as? String
            else {
                assertionFailure("Недопустимый пункт назначения перехода.")
                return
            }
            viewController.fullImageUrl = fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Configure
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    // MARK: - ImagesListViewControllerProtocol Methods
    
    func updateTableView(with newPhotos: [Photo], animated: Bool) {
        let oldCount = photos.count
        let newCount = newPhotos.count
        guard !newPhotos.isEmpty else {
            tableView.reloadData()
            return
        }
        let diff = newCount - oldCount
        photos = newPhotos
        if animated {
            tableView.performBatchUpdates({
                if diff > 0 {
                    let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } else if diff < 0 {
                    let indexPaths = (newCount..<oldCount).map { IndexPath(row: $0, section: 0) }
                    tableView.deleteRows(at: indexPaths, with: .automatic)
                }
            }, completion: nil)
        } else {
            tableView.reloadData()
        }
    }
    
    func navigateToImageController(with url: String) {
        performSegue(withIdentifier: "ShowSingleImage", sender: url)
    }
    
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool) {
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.setIsLiked(isLiked)
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter?.didSelectRowAt(indexPath: indexPath)
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
        presenter?.willDisplayCell(at: indexPath)
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
            cell.setIsLiked(photo.isLiked)
            cell.delegate = self
            return cell
        }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLikeButton(at: indexPath)
    }
}
