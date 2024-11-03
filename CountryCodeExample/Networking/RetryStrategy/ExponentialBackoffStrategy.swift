//
//  ExponentialBackoffStrategy.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

class ExponentialBackoffStrategy: RetryStrategy {
    let maxRetryCount: Int
    let baseDelay: TimeInterval

    init(maxRetryCount: Int = 3,
         baseDelay: TimeInterval = 2) {
        self.maxRetryCount = maxRetryCount
        self.baseDelay = baseDelay
    }

    func shouldRetry(for error: any Error, currentAttempt: Int) -> Bool {
        guard currentAttempt < maxRetryCount else { return false }

        guard let networkError = error as? NetworkError,
              case let .retryNeeded(originalError) = networkError else {
            return false
        }

        return true
    }

    func retryDelay(for attempt: Int) -> TimeInterval {
        return baseDelay * pow(2.0, Double(attempt - 1))
    }
}
