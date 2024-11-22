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
    var posterImage: Observable<UIImage?> { get }

}

protocol MoviewDetailsViewModel: MoviewDetailsViewModelDelegate, MoviesDetailDataSource {}

class DefaultMoviewDetailsViewModel: MoviewDetailsViewModel {
    let posterImageRepository: PosterImageRepository
    private let posterImagePath: String?

    init( model: Movie,
          posterImageRepository: PosterImageRepository) {
        self.posterImageRepository = posterImageRepository
        self.title = model.title
        self.overview = model.overview
        self.posterImagePath = model.posterPath
    }
    
    let title: String
    let overview: String
    var posterImage: Observable<UIImage?> = Observable(item: nil)
    
    func updatePosterImage(width: Int) {
        Task(priority: .userInitiated) {
            guard let posterPath = posterImagePath else { return }
            //TODO: Add Degault image
            posterImage.item =  try? await posterImageRepository.loadImage(posterPath: posterPath, width: width)
        }
        
    }
}
