//
//  Debouncable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/12/24.
//

import Foundation

protocol Debouncable {
    func call(action: @escaping () -> Void)
    func cancel()
}

class DefaultDebouncer: Debouncable {
    private let timeInterval: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    init(timeInterval: TimeInterval = 1,
         queue: DispatchQueue = .main) {
        self.timeInterval = timeInterval
        self.queue = queue
    }

    func call(action: @escaping () -> Void) {
        workItem?.cancel()

        workItem = DispatchWorkItem(block: action)
        if let workItem {
            queue.asyncAfter(deadline: .now() + timeInterval, execute: workItem)
        }
    }

    func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
