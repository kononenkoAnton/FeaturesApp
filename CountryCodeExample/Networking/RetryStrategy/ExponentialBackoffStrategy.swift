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
    let maxDelay: TimeInterval = 30
    let shouldRetryCondition: (Error) -> Bool
    let jitterStrategy: JitterStrategy

    private var previousDelay: TimeInterval?

    init(maxRetryCount: Int = 3,
         baseDelay: TimeInterval = 2,
         jitterStrategy: JitterStrategy = DecorrelatedJitter(),
         shouldRetryCondition: @escaping (Error) -> Bool = { error in
             if let networkError = error as? NetworkError {
                 switch networkError {
                 case .retryNeeded:
                     return true
                 default:
                     return false
                 }
             }
             return false
         }) {
        self.maxRetryCount = maxRetryCount
        self.baseDelay = baseDelay
        self.jitterStrategy = jitterStrategy
        self.shouldRetryCondition = shouldRetryCondition
    }

    func shouldRetry(for error: any Error, currentAttempt: Int) -> Bool {
        guard currentAttempt < maxRetryCount else { return false }

        return shouldRetryCondition(error)
    }

    func retryDelay(for attempt: Int) -> TimeInterval {
        let exponentialDelay = min(baseDelay * pow(2.0, Double(attempt - 1)), maxDelay)
        let jitter = jitterStrategy.calculateRetryDelay(for: exponentialDelay,
                                                        baseDelay: baseDelay,
                                                        maxDelay: maxDelay,
                                                        previousDelay: previousDelay)
        previousDelay = jitter
        return jitter
    }
}
