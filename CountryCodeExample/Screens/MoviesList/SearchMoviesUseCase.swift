//
//  SearchMoviesUseCase.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

protocol SearchMoviesUseCase {
    func execute(searchQuery: SearchQuery) async throws -> [Movie]
}

struct SearchQuery {
    let query: String
    let page: Int
}

enum SearchError: Error {
    case emptyQuery
}

class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let manager: MoviesListManager

    init(manager: MoviesListManager) {
        self.manager = manager
    }

    func execute(searchQuery: SearchQuery) async throws -> [Movie] {
        // Apply any business logic or validation here
        guard !searchQuery.query.isEmpty else {
            throw SearchError.emptyQuery
        }

        // Use the Manager to fetch data
        manager.searchMovies(query: query, completion: completion)
    }
}

// Use Cases (also known as Interactors in some architectures) encapsulate specific business logic or operations that the application can perform. They define what the application does without dictating how it does it.
//
// Role of Use Cases in Architecture
// Encapsulation of Business Logic: They centralize business rules, making them independent of UI or data layers.
// Enhanced Testability: By isolating business operations, use cases can be unit tested without dependencies on UI or external services.
// Clear Separation of Concerns: They promote a clean division between different layers, adhering to the Single Responsibility Principle from SOLID principles.
