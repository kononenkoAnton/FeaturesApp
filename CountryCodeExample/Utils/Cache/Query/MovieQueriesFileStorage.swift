//
//  DefaultQuerySugestion.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/12/24.
//

import Foundation


class MovieQueriesFileStorage<Cache: Storage, LRU: LRUCache> where Cache.Value == [MovieQuery], LRU.Key == String, LRU.Value == MovieQuery {
    private var lruCache: LRU
    let queriesFilePath = "moviewQueries"

    let cache: Cache

    init(cache: Cache,
         lruCache: LRU = DefaultLRUCache<String, MovieQuery>(maxCapacity: 20)
    ) {
        self.cache = cache
        self.lruCache = lruCache
    }

    private func prepapreLRU() {
        Task {
            if let savedQueries = try? await cache.retrieve(forKey: queriesFilePath) {
                for query in savedQueries {
                    await lruCache.store(query.query, value: query)
                }
            }
        }
    }
}

extension MovieQueriesFileStorage: MoviesQueriesStorage {
    func fetchQueries(limit: Int) async throws -> [MovieQuery] {
        var queries = try await cache.retrieve(forKey: queriesFilePath) ?? []
        return Array(queries.prefix(limit))
    }

    func saveQuery(query: MovieQuery) async throws -> MovieQuery {
        await lruCache.store(query.query, value: query)
        let allQueries = await lruCache.retrieveAllValues()
        try await cache.store(forKey: queriesFilePath, value: allQueries)
        return query
    }
}

// extension MovieQueriesFileStorage: MoviesQueriesStorage {
//    func fetchQueries(limit: Int) async throws -> [MovieQuery] {
//        var queries = try await cache.retrieve(forKey: queriesFilePath) ?? []
//        cutQueriesIfLimitExceeded(queries: &queries, limit: limit)
//        return queries
//    }
//
//    func saveQuery(query: MovieQuery) async throws -> MovieQuery {
//        var queries = try await cache.retrieve(forKey: queriesFilePath) ?? []
//        if let index = queries.firstIndex(of: query) {
//            queries.remove(at: index)
//        }
//        queries.insert(query, at: 0)
//
//        if queries.count > maxStorageLimit {
//            queries = Array(queries.prefix(maxStorageLimit))
//        }
//        try await cache.store(forKey: queriesFilePath, value: queries)
//        return query
//    }
//
//    private func cleanQueries(queries: inout [MovieQuery], query: MovieQuery) {
//        removeDuplicates(queries: &queries, query: query)
//        cutQueriesIfLimitExceeded(queries: &queries, limit: maxStorageLimit)
//    }
//
//    private func removeDuplicates(queries: inout [MovieQuery], query: MovieQuery) {
//        queries = queries.filter { $0 != query }
//    }
//
//    private func cutQueriesIfLimitExceeded(queries: inout [MovieQuery], limit: Int) {
//        queries = queries.count < limit ? queries : Array(queries[0 ..< limit])
//    }
// }
