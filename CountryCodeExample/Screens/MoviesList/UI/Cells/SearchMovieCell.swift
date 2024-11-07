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

struct SearchMoviewModel: Hashable {
    let id: UUID = UUID()
    let title: String
    let desciption: String
    let image: UIImage
}

protocol Section: Hashable {
    var id: UUID { get }
    var title: String { get }
}

struct DefaultSection: Section {
    let id: UUID = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

class SearchMovieCell: UITableViewCell, CellIdentifierable {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension SearchMovieCell: CellDataSource {
    func updateData(model: SearchMoviewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.desciption
        posterImageView?.image = model.image
    }
}
