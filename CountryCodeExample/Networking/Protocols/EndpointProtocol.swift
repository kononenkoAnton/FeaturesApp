//
//  EndpointProtocol.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

enum EndpointError: Error {
    case canNotCreateURL
}

protocol EndpointProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var body: [String: String] { get }

    func request(config: APIConfigurable) throws -> URLRequest

    func url(config: APIConfigurable) throws -> URL
}

extension EndpointProtocol {
    func url(config: APIConfigurable) throws -> URL {
        guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true) else {
            throw EndpointError.canNotCreateURL
        }

        components.path = path

        for queryPair in config.query {
            components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
        }

        for queryPair in query {
            components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
        }

        guard let url = components.url else {
            throw EndpointError.canNotCreateURL
        }

        return url
    }

    func request(config: APIConfigurable) throws -> URLRequest {
        var requestURL = config.baseURL

        if config.query.count == 0 || query.count == 0 {
            guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true) else {
                throw EndpointError.canNotCreateURL
            }

            for queryPair in config.query {
                components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
            }

            for queryPair in query {
                components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
            }

            guard let url = components.url else {
                throw EndpointError.canNotCreateURL
            }

            requestURL = url
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        if config.headers.count > 0 {
            for headerPair in config.headers {
                request.setValue(headerPair.value, forHTTPHeaderField: headerPair.key)
            }
        }

        if headers.count > 0 {
            for headerPair in headers {
                request.setValue(headerPair.value, forHTTPHeaderField: headerPair.key)
            }
        }

        if body.count > 0 {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        return request
    }
}
