//
//  Country.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

enum MovieDTOError: Error {
    case canNotParse(id: Int, title: String, underlayingError: Error)
}

struct MovieDTO: Codable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Float
    let posterPath: String?

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

    init(id: Int,
         adult: Bool,
         backdropPath: String?,
         genreIds: [Int],
         originalLanguage: String,
         originalTitle: String,
         overview: String,
         popularity: Float,
         posterPath: String?,
         releaseDate: String,
         title: String,
         video: Bool,
         voteAverage: Float,
         voteCount: Int) {
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        do {
            adult = try container.decode(Bool.self, forKey: .adult)
            backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
            genreIds = try container.decode([Int].self, forKey: .genreIds)
            originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
            originalTitle = try container.decode(String.self, forKey: .originalTitle)
            overview = try container.decode(String.self, forKey: .overview)
            popularity = try container.decode(Float.self, forKey: .popularity)
            posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
            releaseDate = try container.decode(String.self, forKey: .releaseDate)
            video = try container.decode(Bool.self, forKey: .video)
            voteAverage = try container.decode(Float.self, forKey: .voteAverage)
            voteCount = try container.decode(Int.self, forKey: .voteCount)
        } catch {
            throw MovieDTOError.canNotParse(id: id, title: title, underlayingError: error)
        }
    }
}

struct MoviesSearchDTO: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [MovieDTO]

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}
