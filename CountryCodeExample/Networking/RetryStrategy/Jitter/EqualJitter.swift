//
//  EqualJitter.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

// Each retry delay is the calculated exponential backoff delay divided by two plus a random value between 0 and half of that delay.
class EqualJitter: JitterStrategy {
    func calculateRetryDelay(for exponentialDelay: TimeInterval,
                             baseDelay: TimeInterval,
                             maxDelay: TimeInterval,
                             previousDelay: TimeInterval?) -> TimeInterval {
        let halfDelay = exponentialDelay / 2
        let jitter = Double.random(in: 0 ... halfDelay)
        return halfDelay + jitter
    }
}

// Advantages:
//
// Balances between fixed exponential delay and randomness.
// Ensures delays are within a predictable range.
// Disadvantages:
//
// Less randomness compared to full jitter, but still effective in preventing synchronization.
