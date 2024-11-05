//
//  MoviesListManager.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

enum SearchMoviesManagerError {
    case RetriesFailed(originalError: Error)
}

protocol RetryStrategy {
    func shouldRetry(for error: Error,
                     currentAttempt: Int) -> Bool
    func retryDelay(for attempt: Int) -> TimeInterval
}

protocol SearchMoviesManager {
    func searchMovies(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch
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
    private func handleRetry(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch {
        retryAttempt += 1

        let offset = retryStrategy.retryDelay(for: retryAttempt)
        try await Task.sleep(seconds: offset)
        return try await searchMovies(useCaseRequest: useCaseRequest)
    }

    // MARK: MoviesListManagerProtocol

    func searchMovies(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch {
        do {
            let moviewSearch = try await repository.searchMovies(useCaseRequest: useCaseRequest)

            return moviewSearch
        } catch {
            guard retryStrategy.shouldRetry(for: error,
                                            currentAttempt: retryAttempt) else {
                throw error
            }

            return try await handleRetry(useCaseRequest: useCaseRequest)
        }
    }
}
