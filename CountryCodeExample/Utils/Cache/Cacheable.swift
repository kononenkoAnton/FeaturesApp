//
//  Cacheable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/8/24.
//

import Foundation
import UIKit

protocol Cacheable {
    associatedtype Key: Hashable
    associatedtype Value: Hashable
    
    func set(value: Value, forKey key: Key)
    func get(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func removeAll()
}


// protocol Cacheable {
//    associatedtype Key: Hashable
//    associatedtype Value: Hashable
// }
//
// protocol SingleCachable: Cacheable {
//    func set(value: Value, forKey key: Key)
//    func get(forKey key: Key) -> Value?
//    func remove(forKey key: Key)
// }
//
// protocol CollectionCacheable: Cacheable {
//    func getAll() -> [Value]
//    func removeAll()
// }

// protocol SingleCollectionCacheable: SingleCachable, CollectionCacheable {}

protocol NetworkResponseCacheable: Cacheable where Key == URLRequest, Value == CachedURLResponse {}
protocol InMemoryNSCacheable: Cacheable where Key == String, Value: AnyObject {}

protocol TaskCacheable: Cacheable where Key == String, Value == Task<Success, Failure> {
    associatedtype Success: Sendable
    associatedtype Failure: Error
}
