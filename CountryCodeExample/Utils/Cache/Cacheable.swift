//
//  Cacheable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/8/24.
//

import Foundation

typealias CacheKey = Equatable & Hashable
typealias CacheValue = Equatable & Hashable
protocol Cacheable {
    associatedtype Key: CacheKey
    associatedtype Value: CacheValue

    func set(value: Value, forKey key: Key)
    func get(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func clearAll()
}

protocol NetworkResponseCacheable {
    func set(value: CachedURLResponse, forKey key: URLRequest)
    func get(forKey key: URLRequest) -> CachedURLResponse?
    func remove(forKey key: URLRequest)
    func clearAll()
}
