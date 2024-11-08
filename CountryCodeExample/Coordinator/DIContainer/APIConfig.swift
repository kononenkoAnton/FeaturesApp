//
//  APIConfig.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

final class ApplicationAPIConfig {
    private let infoDictionary: [String: Any]? = Bundle.main.infoDictionary

    private enum Keys {
        static let apiBaseURL = "API_BASE_URL"
        static let accessTokenAuth = "ACCESS_TOKEN_AUTH"
        static let imageBaseURL = "IMAGE_BASE_URL"
    }

    let baseURL: String = {
        guard let urlString = Bundle.main.infoDictionary?[Keys.apiBaseURL] as? String else {
            fatalError("The API base URL ('\(Keys.apiBaseURL)') is missing or invalid in the .xcconfig file.")
        }
        return urlString
    }()

    let accessTokenAuth: String = {
        guard let token = Bundle.main.infoDictionary?[Keys.accessTokenAuth] as? String else {
            fatalError("The access token ('\(Keys.accessTokenAuth)') is missing or invalid in the .xcconfig file.")
        }
        return token
    }()

    let imageBaseURL: String = {
        guard let imageUrlString = Bundle.main.infoDictionary?[Keys.imageBaseURL] as? String else {
            fatalError("The Image base URL ('\(Keys.apiBaseURL)') is missing or invalid in the .xcconfig file.")
        }
        return imageUrlString
    }()
}
