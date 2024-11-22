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
    func execute(useCaseRequest: SearchMoviewRequest) async throws -> MoviesSearch
}

enum SearchError: Error {
    case emptyQuery
}



class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let manager: SearchMoviesManager
    private let queryRepository: MoviesQueryRepository
    private var loadingTask: Task<MoviesSearch, Error>?

    init(manager: SearchMoviesManager,
         queryRepository: MoviesQueryRepository) {
        self.manager = manager
        self.queryRepository = queryRepository
    }

    func execute(useCaseRequest: SearchMoviewRequest) async throws -> MoviesSearch {
        
        guard !useCaseRequest.isQueryEmpty else {
            throw SearchError.emptyQuery
        }
        
        do {
            let task = Task(priority: .userInitiated) {
                let searchResult = try await manager.searchMovies(useCaseRequest: useCaseRequest)
                try await queryRepository.saveQuery(query: useCaseRequest.query)

                return searchResult
            }

            loadingTask = task
            let moviesSearch = try await task.value
            loadingTask = nil

            return moviesSearch
        } catch {
            print(error)
            throw error
        }
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
