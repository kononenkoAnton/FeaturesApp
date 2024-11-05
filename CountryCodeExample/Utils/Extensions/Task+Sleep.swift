//
//  Task+Sleep.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//
import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1000000000)
        try await Task.sleep(nanoseconds: duration)
    }
}
