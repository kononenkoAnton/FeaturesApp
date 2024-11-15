//
//  FileBasedCache.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
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
    case fileNotFound
    case failedToCreateDirectory(underlyingError: Error)
    case failedToEncodeData(underlyingError: Error)
    case failedToDecodeData(underlyingError: Error)
    case failedToWriteData(underlyingError: Error)
    case failedToRemoveItem(underlyingError: Error)
}

actor DefaultFileBasedCache<Value: Hashable & Codable, Key: Hashable>: Storage {
    private let fileManager: FileManagerProtocol
    private let cacheDirectoryURL: URL
    init(fileManager: FileManagerProtocol = FileManager.default,
         cacheURLFolder: URL) {
        self.fileManager = fileManager
        cacheDirectoryURL = cacheURLFolder
    }

    private func urlForKey(path: String) -> URL {
        cacheDirectoryURL.appendingPathComponent(path)
    }

    private func ensureCacheDirectoryExists() throws {
        do {
            try fileManager.createDirectory(at: cacheDirectoryURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            throw FileManagerError.failedToCreateDirectory(underlyingError: error)
        }
    }

    func retrieve(forKey key: String) async throws -> Value? {
        let url = urlForKey(path: key)

        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            throw FileManagerError.failedToDecodeData(underlyingError: error)
        }
    }

    func store(forKey key: String, value: Value) async throws {
        let url = urlForKey(path: key)
        try ensureCacheDirectoryExists()
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            throw FileManagerError.failedToWriteData(underlyingError: error)
        }
    }

    func deleteValue(forKey key: String) async throws {
        let url = urlForKey(path: key)

        guard fileManager.fileExists(atPath: url.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw FileManagerError.failedToRemoveItem(underlyingError: error)
        }
    }

    func clearCache() async throws {
        do {
            guard fileManager.fileExists(atPath: cacheDirectoryURL.path) else {
                return
            }

            try fileManager.removeItem(at: cacheDirectoryURL)
            try ensureCacheDirectoryExists()
        } catch {
            throw FileManagerError.failedToRemoveItem(underlyingError: error)
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
