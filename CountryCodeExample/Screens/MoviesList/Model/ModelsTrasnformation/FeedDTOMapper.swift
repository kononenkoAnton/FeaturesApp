//
//  FeedMapper.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation
class FeedDTOMapper: DTOMapperProtocol {
    private let releaseDateDateFormat = "yyyy-MM-dd"
    private let logger: SearchDTOMapperErrorLoggable

    init(logger: SearchDTOMapperErrorLoggable = SearchDTOMapperError()) {
        self.logger = logger
    }

    func mapToDomain(from modelDTO: MoviesSearchResultDTO) -> MoviesSearchResult {
        // As alternative could be used ISO8601DateFormatter represents same format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = releaseDateDateFormat
        let movies: [Movie] = modelDTO.results.compactMap { movieDTO in
            guard let releaseDate = dateFormatter.date(from: movieDTO.releaseDate) else {
                logger.logErrorDateFormat(movie: movieDTO)
                return nil
            }

            return Movie(id: movieDTO.id,
                         adult: movieDTO.adult,
                         backdropPath: movieDTO.backdropPath,
                         genreIds: movieDTO.genreIds,
                         originalLanguage: movieDTO.originalLanguage,
                         originalTitle: movieDTO.originalTitle,
                         overview: movieDTO.overview,
                         popularity: movieDTO.popularity,
                         posterPath: movieDTO.posterPath,

                         releaseDate: releaseDate,
                         title: movieDTO.title,
                         video: movieDTO.video,
                         voteAverage: movieDTO.voteAverage,
                         voteCount: movieDTO.voteCount)
        }

        return MoviesSearchResult(page: modelDTO.page,
                                  totalPages: modelDTO.totalPages,
                                  totalResults: modelDTO.totalResults,
                                  results: movies)
    }

    func mapToDTO(from modelDoman: MoviesSearchResult) -> MoviesSearchResultDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = releaseDateDateFormat
        let movies = modelDoman.results.map { movie in
            MovieDTO(id: movie.id,
                     adult: movie.adult,
                     backdropPath: movie.backdropPath,
                     genreIds: movie.genreIds,
                     originalLanguage: movie.originalLanguage,
                     originalTitle: movie.originalTitle,
                     overview: movie.overview,
                     popularity: movie.popularity,
                     posterPath: movie.posterPath,
                     releaseDate: dateFormatter.string(from: movie.releaseDate),
                     title: movie.title,
                     video: movie.video,
                     voteAverage: movie.voteAverage,
                     voteCount: movie.voteCount)
        }

        return MoviesSearchResultDTO(page: modelDoman.page,
                                     totalPages: modelDoman.totalPages,
                                     totalResults: modelDoman.totalResults,
                                     results: movies)
    }
}
