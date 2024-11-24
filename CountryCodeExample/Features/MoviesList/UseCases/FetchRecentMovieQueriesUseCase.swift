//
//  FetchRecentMovieQueriesUseCase.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/18/24.
//

protocol FetchRecentMovieQueriesUseCase {
    func execute() async -> [MovieQuery]
}

class DefaultFetchRecentMovieQueriesUseCase: FetchRecentMovieQueriesUseCase {
    struct RequestValue {
        let maxCount: Int
    }
    
    let requestValue: RequestValue
    let moviesQueriesRepository: MoviesQueryRepository
    init(requestValue: RequestValue,
         moviesQueriesRepository: MoviesQueryRepository) {
        self.requestValue = requestValue
        self.moviesQueriesRepository = moviesQueriesRepository
    }

    func execute() async -> [MovieQuery] {
        do {
            return try await moviesQueriesRepository.fetchQueries(limit: requestValue.maxCount)
        } catch {
            return []
        }
    }

}

extension DefaultFetchRecentMovieQueriesUseCase: Cancelable {
    func cancel() {
    }
}
