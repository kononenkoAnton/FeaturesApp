//
//  JitterStrategy.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

protocol JitterStrategy {
    func calculateRetryDelay(for exponentialDelay: TimeInterval,
                             baseDelay: TimeInterval,
                             maxDelay: TimeInterval,
                             previousDelay: TimeInterval?) -> TimeInterval
}
