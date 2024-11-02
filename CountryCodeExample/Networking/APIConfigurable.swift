//
//  APIConfigurable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

protocol APIConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
}

protocol EndpointProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var body: [String: String] { get }

    func request(config: APIConfigurable) throws -> URLRequest

    func url(config: APIConfigurable) throws -> URL
}

enum RequestError: Error {
    case canNotCreateURL
}

extension EndpointProtocol {
    func url(config: APIConfigurable) throws -> URL {
        guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true) else {
            throw RequestError.canNotCreateURL
        }

        components.path = path

        for queryPair in config.query {
            components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
        }

        for queryPair in query {
            components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
        }

        guard let url = components.url else {
            throw RequestError.canNotCreateURL
        }

        return url
    }

    func request(config: APIConfigurable) throws -> URLRequest {
        var requestURL = config.baseURL

        if config.query.count == 0 || query.count == 0 {
            guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true) else {
                throw RequestError.canNotCreateURL
            }

            for queryPair in config.query {
                components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
            }

            for queryPair in query {
                components.queryItems?.append(URLQueryItem(name: queryPair.key, value: queryPair.value))
            }

            guard let url = components.url else {
                throw RequestError.canNotCreateURL
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
