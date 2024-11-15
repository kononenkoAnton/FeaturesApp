//
//  MoviesQueriesStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//

protocol MoviesQueriesStorage {
    func fetchQueries(limit: Int) async throws -> [MovieQuery]
    func saveQuery(query: MovieQuery) async throws -> MovieQuery
}
