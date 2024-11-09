//
//  InMemoryImageCache.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/8/24.
//

import Foundation
import UIKit

class DefaultInMemoryNSCacheable: InMemoryNSCacheable {
    var cache: NSCache<NSString, UIImage> = NSCache()

    init(countLimit: Int = 50 * 1024 * 1024,
         totalCostLimit: Int = 100) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearAll),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    func set(value: UIImage, forKey key: String) {
        cache.setObject(value, forKey: key as NSString, cost: value.memorySize)
    }

    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    @objc func clearAll() {
        cache.removeAllObjects()
    }
}
