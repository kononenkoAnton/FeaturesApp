//
//  Country.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

struct MovieDTO: Codable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Float
    let posterPath: String
    
    /// Description: "yyyy-MM-dd"
    /// Example: "2006-12-12"
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MoviesSearchResultDTO: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages
        case totalResults = "total_results"
        case results
    }
}

