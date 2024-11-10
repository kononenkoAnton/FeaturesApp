//
//  DefaultURLRequestCache.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/8/24.
//

import Foundation

class URLRequestCache: NetworkResponseCacheable {
    let cache: URLCache

    func set(value: CachedURLResponse,
             forKey key: URLRequest) {
        cache.storeCachedResponse(value,
                                  for: key)
    }

    func get(forKey key: URLRequest) -> CachedURLResponse? {
        cache.cachedResponse(for: key)
    }

    func remove(forKey key: URLRequest) {
        cache.removeCachedResponse(for: key)
    }

    func removeAll() {
        cache.removeAllCachedResponses()
    }

    init(memoryCapacity: Int = 50 * 1024 * 1024,
         diskCapacity: Int = 100 * 1024 * 1024,
         diskPath: String = "DefaultAppCache") {
        cache = URLCache(memoryCapacity: memoryCapacity,
                         diskCapacity: diskCapacity,
                         diskPath: diskPath)
    }
}
