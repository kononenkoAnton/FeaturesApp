//
//  MoviewSearchViewModelModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/10/24.
//

import Foundation
import UIKit

class MoviewSearchViewModel {
    let id: UUID = UUID()
    let title: String
    let overview: String
    let posterPath: String?

    weak var posterImageRepository: PosterImageRepository?

    @discardableResult
    func loadImage(width: Int) async -> UIImage? {
        guard let posterPath else {
            return nil
        }

        // TODO: handle gracefully
        return try? await posterImageRepository?.loadImage(posterPath: posterPath, width: width)
    }

    func cancelLoad(width: Int) {
        if let posterPath {
            // TODO: handle gracefully
            try? posterImageRepository?.cancelLoad(posterPath: posterPath, width: width)
        }
    }

    init(title: String,
         overview: String,
         posterPath: String?,
         posterImageRepository: PosterImageRepository) {
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.posterImageRepository = posterImageRepository
    }
}

extension MoviewSearchViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MoviewSearchViewModel,
                    rhs: MoviewSearchViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
