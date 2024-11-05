//
//  SearchMoviesUseCase.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

protocol Cancelable {
    func cancel()
}

protocol SearchMoviesUseCase: Cancelable {
    func execute(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch
}

enum SearchError: Error {
    case emptyQuery
}

class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let manager: DefaultSearchMoviesManager
    private var loadingTask: Task<MoviesSearch, Error>? // TODO: Should be repository error or somethign

    init(manager: DefaultSearchMoviesManager) {
        self.manager = manager
    }

    func execute(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch {
        // Apply any business logic or validation here
        guard !useCaseRequest.query.isEmpty else {
            throw SearchError.emptyQuery
        }

        let task = Task(priority: .userInitiated) {
            // Use the Manager to fetch data
            try await manager.searchMovies(useCaseRequest: useCaseRequest)
        }

        loadingTask = task
        let moviesSearch = try await task.value
        loadingTask = nil

        return moviesSearch
    }

    func cancel() {
        loadingTask?.cancel()
        loadingTask = nil
    }
}

// Use Cases (also known as Interactors in some architectures) encapsulate specific business logic or operations that the application can perform. They define what the application does without dictating how it does it.
//
// Role of Use Cases in Architecture
// Encapsulation of Business Logic: They centralize business rules, making them independent of UI or data layers.
// Enhanced Testability: By isolating business operations, use cases can be unit tested without dependencies on UI or external services.
// Clear Separation of Concerns: They promote a clean division between different layers, adhering to the Single Responsibility Principle from SOLID principles.
