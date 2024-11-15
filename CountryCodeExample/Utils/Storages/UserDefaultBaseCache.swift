//
//  MovieQueriesUserDefaultStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//

import Foundation

protocol UserDefaultProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func value(forKey key: String) -> Any?
    func data(forKey key: String) -> Data?
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultProtocol {}

enum UserDefaultsCacheError: Error {
    case encodingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
}

actor UserDefaultsCache<Value: Hashable & Codable, Key: Hashable>: Storage {
    private let storageName: String
    private let userDefaults: UserDefaultProtocol
    private var storedKeys: Set<String>

    init(userDefaults: UserDefaultProtocol = UserDefaults.standard,
         storageName: String = "com.userDefaults.default") {
        self.userDefaults = userDefaults
        self.storageName = storageName
        storedKeys = userDefaults.value(forKey: storageName) as? Set<String> ?? []
    }

    func retrieve(forKey key: String) async throws -> Value? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            throw UserDefaultsCacheError.decodingFailed(underlyingError: error)
        }
    }

    func store(forKey key: String, value: Value) async throws {
        do {
            let data = try JSONEncoder().encode(value)
            let namespacedKey = createKey(from: key)
            userDefaults.set(data, forKey: namespacedKey)
            storeInStoredKeys(key: namespacedKey)
        } catch {
            throw UserDefaultsCacheError.encodingFailed(underlyingError: error)
        }
    }

    func deleteValue(forKey key: String) async throws {
        let namespacedKey = createKey(from: key)
        userDefaults.removeObject(forKey: namespacedKey)
        deleteFromStoredKeys(key: namespacedKey)
    }

    func clearCache() async throws {
        for key in storedKeys {
            userDefaults.removeObject(forKey: key)
        }

        userDefaults.removeObject(forKey: storageName)
    }

    private func createKey(from key: String) -> String {
        storageName + "." + key
    }

    private func storeInStoredKeys(key: String) {
        storedKeys.insert(key)
        userDefaults.set(storedKeys, forKey: storageName)
    }

    private func deleteFromStoredKeys(key: String) {
        storedKeys.remove(key)
        userDefaults.set(storedKeys, forKey: storageName)
    }
}
