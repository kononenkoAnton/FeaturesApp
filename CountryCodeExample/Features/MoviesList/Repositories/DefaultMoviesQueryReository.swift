//
//  DefaultMoviesQueryReository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/13/24.
//

protocol MoviesQueryRepository {
    func fetchQueries(limit: Int) async throws -> [MovieQuery]

    @discardableResult
    func saveQuery(query: MovieQuery) async throws -> MovieQuery
}

class DefaultMoviesQueryReository {
    let storage: MoviesQueriesStorage

    init(storage: MoviesQueriesStorage) {
        self.storage = storage
    }
}

extension DefaultMoviesQueryReository: MoviesQueryRepository {
    func saveQuery(query: MovieQuery) async throws -> MovieQuery {
        try await storage.saveQuery(query: query)
    }

    func fetchQueries(limit: Int) async throws -> [MovieQuery] {
        try await storage.fetchQueries(limit: limit)
    }

    func saveQuery(qery: MovieQuery) async throws {
        try await storage.saveQuery(query: qery)
    }
}
