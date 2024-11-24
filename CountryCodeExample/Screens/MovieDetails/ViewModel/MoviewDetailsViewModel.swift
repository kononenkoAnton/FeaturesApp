//
//  MoviewDetailsViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/22/24.
//
import Foundation
import UIKit

protocol MoviewDetailsViewModelDelegate {
    func updatePosterImage(width: Int)
}

protocol MoviesDetailDataSource {
    var title: String { get }
    var overview: String { get }
    var releasedDate: String { get }
    var posterImage: Observable<UIImage?> { get }
}

protocol MoviewDetailsViewModel: MoviewDetailsViewModelDelegate, MoviesDetailDataSource {}

class DefaultMoviewDetailsViewModel: MoviewDetailsViewModel {
    let posterImageRepository: PosterImageRepository
    private let posterImagePath: String?

    init(model: Movie,
         posterImageRepository: PosterImageRepository) {
        self.posterImageRepository = posterImageRepository
        title = model.title
        overview = model.overview
        posterImagePath = model.posterPath

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        releasedDate = dateFormatter.string(from: model.releaseDate)
    }

    let title: String
    let overview: String
    let releasedDate: String
    var posterImage: Observable<UIImage?> = Observable(item: nil)

    func prepareReleasedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.string(from: date)
    }

    func updatePosterImage(width: Int) {
        Task(priority: .userInitiated) {
            guard let posterPath = posterImagePath else { return }
            // TODO: Add Degault image
            posterImage.item = try? await posterImageRepository.loadImage(posterPath: posterPath, width: width)
        }
    }
}
