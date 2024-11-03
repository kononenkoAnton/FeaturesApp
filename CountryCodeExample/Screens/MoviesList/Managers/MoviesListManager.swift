//
//  MoviesListManager.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

enum MoviesListManagerError {
    case endpointError(error: EndpointError)
    case networkError(error: NetworkError)
    case repository(error: NetworkError)
}

protocol RetryStrategy {
    func shouldRetry(for error: Error,
                     currentAttempt: Int) -> Bool
    func retryDelay(for attempt: Int) -> TimeInterval
}

protocol LoadingCancelable {
    func cancel()
}

protocol MoviesListManagerProtocol: LoadingCancelable {
    // TODO: Could be added query and pagination
    func loadMoviewList() async throws -> Feed
}

class MoviesListManager: MoviesListManagerProtocol {
    let repository: MoviesListRepositoryProtocol
    let retryStrategy: RetryStrategy
    private var loadingTask: Task<Feed, Error>? // TODO: Should be repository error or somethign
    init(repository: MoviesListRepositoryProtocol,
         retryStrategy: RetryStrategy = ExponentialBackoffStrategy()) {
        self.retryStrategy = retryStrategy
        self.repository = repository
    }

    // MARK: MoviesListManagerProtocol

    func cancel() {
        loadingTask?.cancel()
        loadingTask = nil
    }

    func loadMoviewList() async throws -> Feed {
        let task = Task(priority: .userInitiated) {
            try await repository.loadMovilesList()
        }

        loadingTask = task
        let feed = try await task.value
        loadingTask = nil

        return feed
    }
}
