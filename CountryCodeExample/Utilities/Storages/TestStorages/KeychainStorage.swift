//
//  KeychainStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//

import Foundation
import Security
//TODO: Just test, not implemnted fully
actor KeychainStorage<Value: Hashable & Codable, Key: Hashable>: Storage {
    func retrieve(forKey key: String) async throws -> Value? {
        var query = keychainQuery(forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

        guard status != errSecItemNotFound else {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.invalidData
        }

        do {
            let value = try JSONDecoder().decode(Value.self, from: data)
            return value
        } catch {
            throw KeychainError.decodingFailed(underlyingError: error)
        }
    }

    func store(forKey key: String, value: Value) async throws {
        let data: Data
        do {
            data = try JSONEncoder().encode(value)
        } catch {
            throw KeychainError.encodingFailed(underlyingError: error)
        }

        var query = keychainQuery(forKey: key)
        let attributesToUpdate = [kSecValueData as String: data]

        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.unhandledError(status: addStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func deleteValue(forKey key: String) async throws {
        let query = keychainQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func clearCache() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // Helper methods
    private func keychainQuery(forKey key: String) -> [String: Any] {
        let encodedIdentifier = key.data(using: .utf8)!
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.example.app",
            kSecAttrAccount as String: encodedIdentifier,
        ]
    }

    enum KeychainError: Error {
        case encodingFailed(underlyingError: Error)
        case decodingFailed(underlyingError: Error)
        case invalidData
        case unhandledError(status: OSStatus)
    }
}
