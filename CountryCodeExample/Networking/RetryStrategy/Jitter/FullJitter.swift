//
//  FullJitter.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

// Each retry delay is a random value between 0 and the calculated exponential backoff delay.
//
class FullJitter: JitterStrategy {
    func calculateRetryDelay(for exponentialDelay: TimeInterval,
                             baseDelay: TimeInterval,
                             maxDelay: TimeInterval,
                             previousDelay: TimeInterval?) -> TimeInterval {
        return Double.random(in: 0 ... exponentialDelay)
    }
}

// Advantages:
//
// Maximizes randomness, effectively spreading out retries.
// Reduces the chance of synchronized retries.

// Disadvantages:
//
// Retry delays can be significantly shorter or longer than the base exponential delay.
