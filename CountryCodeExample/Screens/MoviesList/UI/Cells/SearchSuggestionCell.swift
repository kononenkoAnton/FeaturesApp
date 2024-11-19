//
//  SearchSuggestionCell.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/16/24.
//

import UIKit

class SearchSuggestionCell: UITableViewCell, CellIdentifierable {
    static let cellHeight:CGFloat = 50.0
    var model: MovieQuery?

    override func prepareForReuse() {
        model = nil
    }
}

extension SearchSuggestionCell: CellDataSource {
    func updateData(model: MovieQuery) {
        var configuration = defaultContentConfiguration()
        configuration.text = model.query
        configuration.textProperties.alignment = .center
        configuration.textProperties.font = UIFont.preferredFont(forTextStyle: .title3)

        contentConfiguration = configuration

    }
}
