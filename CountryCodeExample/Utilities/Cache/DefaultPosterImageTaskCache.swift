//
//  DefaultPosterImageLoadingTask.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/10/24.
//

import UIKit

class DefaultPosterImageTaskCache: TaskCacheable {
    typealias Success = UIImage

    typealias Failure = Never

    typealias LoadingTask = Task<UIImage, Never>
    var tasks: [String: LoadingTask] = [:]

    func set(value: LoadingTask, forKey key: String) {
        tasks[key] = value
    }

    func get(forKey key: String) -> LoadingTask? {
        tasks[key]
    }

    func remove(forKey key: String) {
        guard let task = get(forKey: key) else {
            return
        }

        task.cancel()
        tasks[key] = nil
    }

    func removeAll() {
        tasks.keys.forEach { key in
            remove(forKey: key)
        }
    }
}
