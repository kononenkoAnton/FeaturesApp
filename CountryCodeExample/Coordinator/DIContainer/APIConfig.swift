//
//  APIConfig.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

final class ApplicationAPIConfig {
    var baseURL: String {
        guard let urlString = Bundle.main.infoDictionary?["API_BASE_URL"] as? String else {
            fatalError("Base URL is missing or invalid in .xcconfig")
        }

        return urlString
    }
}
