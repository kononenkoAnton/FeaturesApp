//
//  ImageSizeWidthMatcher.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/7/24.
//

import Foundation

struct ImageSizeWidthMatcher {
    let matchData: [Int]
    private let originalSize = "original"
    init(matchData: [Int]) {
        self.matchData = matchData.sorted()
    }

    func matchSize(width: Int) -> String {
        guard !matchData.isEmpty else {
            return originalSize
        }

        guard let lastItem = matchData.last,
              width > lastItem else {
            let minimalDifference = matchData.map { abs($0 - width) }.min() ?? 0
            let closestMatches = matchData.filter { abs($0 - width) == minimalDifference }
            let matchResult = closestMatches.max() ?? matchData.first!
            return "w\(matchResult)"
        }

        return originalSize
    }
}
