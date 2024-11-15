//
//  Storage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//

protocol Storage: Actor {
    associatedtype Key: Hashable
    associatedtype Value: Hashable & Codable
    
    func retrieve(forKey key: String) async throws -> Value?
    func store(forKey key: String,
               value: Value) async throws
    func deleteValue(forKey key: String) async throws
    func clearCache() async throws
}
