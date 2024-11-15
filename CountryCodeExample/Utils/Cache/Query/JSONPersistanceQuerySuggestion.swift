//
//  DefaultQuerySugestion.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/12/24.
//

import Foundation

protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory,
              in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func fileExists(atPath path: String) -> Bool
    func removeItem(at URL: URL) throws
    func createDirectory(at url: URL,
                         withIntermediateDirectories createIntermediates: Bool,
                         attributes: [FileAttributeKey: Any]?) throws
    func contentsOfDirectory(at url: URL,
                             includingPropertiesForKeys keys: [URLResourceKey]?,
                             options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
}

extension FileManager: FileManagerProtocol {}

enum FileManagerError: Error {
    case general(error: Error)
    case decodingFailed(error: Error)
    case dataReadingFailed(error: Error)
    case encodingFailed(error: Error)
    case dataWriteFailed(error: Error)
    case fileRemovalFailed(error: Error)
    case directoryRemovalFailed(error: Error)
}

protocol MoviesQueriesStorage {
    func fetchQueries(limit: Int) async throws -> [MovieQuery]
    func saveQuery(query: MovieQuery) async throws -> MovieQuery
}

class DefaultQueriesStorage<Cache: FileManagerCache> where Cache.Value == [MovieQuery] {
    private let maxStorageLimit: Int
    let queriesPath = "moviewQueries"

    let cache: Cache

    init(cache: Cache,
         maxStorageLimit: Int = 20) {
        self.cache = cache
        self.maxStorageLimit = maxStorageLimit
    }
}

extension DefaultQueriesStorage: MoviesQueriesStorage {
    func fetchQueries(limit: Int) async throws -> [MovieQuery] {
        return try await Task(priority: .userInitiated) {
            var queries = try await cache.get(forKey: queriesPath) ?? []
            cutQueriesIfLimitExceeded(queries: &queries, limit: limit)
            return queries
        }.value
    }

    func saveQuery(query: MovieQuery) async throws -> MovieQuery {
        return try await Task(priority: .userInitiated) {
            var newQueries: [MovieQuery] = try await cache.get(forKey: queriesPath) ?? [query]
            cleanQueries(queries: &newQueries, query: query)
            newQueries.insert(query, at: 0)

            try await cache.set(forKey: queriesPath,
                                value: newQueries)

            return query
        }.value
    }

    private func cleanQueries(queries: inout [MovieQuery], query: MovieQuery) {
        removeDuplicates(queries: &queries, query: query)
        cutQueriesIfLimitExceeded(queries: &queries, limit: maxStorageLimit)
    }

    private func removeDuplicates(queries: inout [MovieQuery], query: MovieQuery) {
        queries = queries.filter { $0 != query }
    }

    private func cutQueriesIfLimitExceeded(queries: inout [MovieQuery], limit: Int) {
        queries = queries.count < limit ? queries : Array(queries[0 ..< limit])
    }
}

protocol FileManagerCache: Actor {
    associatedtype Value: Hashable & Codable

    func get(forKey key: String) async throws -> Value?
    func set(forKey key: String,
             value: Value) async throws
    func remove(forKey key: String) async throws
    func removeAll() async throws
}

actor FileManagerWrappers<Value: Hashable & Codable>: FileManagerCache {
    private let fileManager: FileManagerProtocol
    private let cacheURLFolder: URL
    init(fileManager: FileManagerProtocol = FileManager.default,
         cacheURLFolder: URL) {
        self.fileManager = fileManager
        self.cacheURLFolder = cacheURLFolder
//        if let cacheURLFolder {
//            self.cacheURLFolder = cacheURLFolder
//        } else {
//            guard let documentsURL = fileManager.urls(for: .documentDirectory,
//                                                      in: .userDomainMask) else {
//                throw FileManagerError.cannotCreateURLForFolder(cacheFolder)
//            }
//
//            self.cacheURLFolder = documentsURL.appendingPathComponent(cacheFolder)
//        }
    }

    private func fileURL(path: String) -> URL {
        cacheURLFolder.appendingPathComponent(path)
    }

    private func createFolderIfNeeded() throws {
        guard !fileManager.fileExists(atPath: cacheURLFolder.path) else {
            return
        }

        do {
            try fileManager.createDirectory(at: cacheURLFolder,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            throw FileManagerError.general(error: error)
        }
    }

    func get(forKey key: String) async throws -> Value? {
        let url = fileURL(path: key)

        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(Value.self, from: data)
            return model
        } catch let error as DecodingError {
            throw FileManagerError.decodingFailed(error: error)
        } catch {
            throw FileManagerError.dataReadingFailed(error: error)
        }
    }

    func set(forKey key: String,
             value: Value) async throws {
        let url = fileURL(path: key)
        try createFolderIfNeeded()

        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch let error as EncodingError {
            throw FileManagerError.encodingFailed(error: error)
        } catch {
            throw FileManagerError.dataWriteFailed(error: error)
        }
    }

    func remove(forKey key: String) async throws{
        let url = fileURL(path: key)
    
        guard fileManager.fileExists(atPath: url.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw FileManagerError.fileRemovalFailed(error: error)
        }
    }

    func removeAll() async throws {
        do {
            guard fileManager.fileExists(atPath: cacheURLFolder.path) else {
                return
            }

            try fileManager.removeItem(at: cacheURLFolder)
            try createFolderIfNeeded()
        } catch {
            throw FileManagerError.directoryRemovalFailed(error: error)
        }
    }
}

// actor DefaultQueryCache2 {
//    // Internal storage for caching
//    private var storage: [String: Any] = [:]
//
//    // Generic get method without unnecessary constraints
//    func get<T>(type: T.Type = T.self, forKey key: String) throws -> T? {
//        var storage: [String: T] = [:]
//        return storage[key]
//    }
//
//    // Method to set values in the cache
//    func set<T>(value: T, forKey key: String) {
//        storage[key] = value
//    }
// }
