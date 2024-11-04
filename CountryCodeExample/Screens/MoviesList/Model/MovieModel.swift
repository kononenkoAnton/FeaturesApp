//
//  Models.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

struct Movie {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Float
    let posterPath: String
    let releaseDate: Date
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
}

struct MoviesSearchResult {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]
}

