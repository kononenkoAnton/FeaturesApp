//
//  DecorrelatedJitter.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

// Each retry delay is a random value between a minimum delay and the previous delay multiplied by a factor (typically greater than 1).
class DecorrelatedJitter: JitterStrategy {
    func calculateRetryDelay(for exponentialDelay: TimeInterval,
                             baseDelay: TimeInterval,
                             maxDelay: TimeInterval,
                             previousDelay:TimeInterval?) -> TimeInterval {
        // If there's no previous delay, use the baseDelay
        let previous = previousDelay ?? baseDelay

        // Calculate the upper bound for the current delay
        let upperBound = min(previous * 3, maxDelay)

        // Calculate the delay using Decorrelated Jitter formula
        let delay = Double.random(in: baseDelay ... upperBound)

        return delay
    }
}

//Handling previousDelay:
//If previousDelay is nil (i.e., the first retry), it uses baseDelay as the previous delay.
//Calculating Upper Bound:
//The upper bound for the current delay is three times the previousDelay, capped at maxDelay.
//Random Delay Calculation:
//The new delay is a random value between baseDelay and the calculated upperBound, adhering to the Decorrelated Jitter formula.

// Advantages:
//
// More dynamic and adapts to varying network conditions.
// Prevents retries from growing too quickly or too slowly.
// Disadvantages:
//
// Slightly more complex to implement.

// Key Enhancements:
// Maximum Delay Cap (maxDelay):
// Prevents delays from growing too large, ensuring that retries don’t become impractically long.
// Full Jitter Implementation:
// Introduces randomness to each retry delay, reducing the risk of synchronized retries.

