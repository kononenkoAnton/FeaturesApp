//
//  MoviesListManager.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

enum SearchMoviesManagerError: Error {
    case retriesFailed(originalError: Error)
}

protocol RetryStrategy {
    func shouldRetry(for error: Error,
                     currentAttempt: Int) -> Bool
    func retryDelay(for attempt: Int) -> TimeInterval
}

protocol SearchMoviesManager {
    func searchMovies(useCaseRequest: SearchMoviewRequest) async throws -> MoviesSearch
}


class DefaultSearchMoviesManager: SearchMoviesManager {
    let repository: SearchMoviewRepository
    let retryStrategy: RetryStrategy
    init(repository: SearchMoviewRepository,
         retryStrategy: RetryStrategy = ExponentialBackoffStrategy()) {
        self.retryStrategy = retryStrategy
        self.repository = repository
    }

    private var retryAttempt = 0
    private func handleRetry(useCaseRequest: SearchMoviewRequest) async throws -> MoviesSearch {
        retryAttempt += 1

        let offset = retryStrategy.retryDelay(for: retryAttempt)
        try await Task.sleep(seconds: offset)
        return try await searchMovies(useCaseRequest: useCaseRequest)
    }

    // MARK: MoviesListManagerProtocol

    func searchMovies(useCaseRequest: SearchMoviewRequest) async throws -> MoviesSearch {
        do {
            let moviewSearch = try await repository.searchMovies(useCaseRequest: useCaseRequest)

            return moviewSearch
        } catch {
            guard retryStrategy.shouldRetry(for: error,
                                            currentAttempt: retryAttempt) else {
                throw SearchMoviesManagerError.retriesFailed(originalError: error)
            }

            return try await handleRetry(useCaseRequest: useCaseRequest)
        }
    }
}
