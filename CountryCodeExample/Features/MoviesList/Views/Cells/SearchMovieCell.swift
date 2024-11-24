//
//  SearchMovieCell.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/6/24.
//

import UIKit

protocol CellIdentifierable {
    static var cellIdentifier: String { get }
}

extension CellIdentifierable {
    static var cellIdentifier: String {
        String(describing: Self.self)
    }
}

protocol CellDataSource {
    associatedtype Model
    func updateData(model: Model)
}

enum DefaultSection {
    case main
}

class SearchMovieCell: UITableViewCell, CellIdentifierable {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    weak var viewModel: MoviewSearchViewModel?

    override func prepareForReuse() {
        super.prepareForReuse()

        posterImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}

extension SearchMovieCell: CellDataSource {
    func updateData(model: MoviewSearchViewModel) {
        viewModel = model
        titleLabel.text = model.title
        descriptionLabel.text = model.overview
        posterImageView.image = .moviewSearchPlaceholder
        loadImage()
    }

    func loadImage() {
        Task(priority: .userInitiated) {
            let image = await viewModel?.loadImage(width: 66)
            Task { @MainActor in
                if let image {
                    posterImageView.image = image
                }
            }
        }
    }
}
