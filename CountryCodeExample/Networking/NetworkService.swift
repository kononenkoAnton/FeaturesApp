//
//  NetworkService.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

class DefaultNetworkService: NetworkServiceProtocol {
    // TODO: Add logger, error, response, request
    let config: APIConfigurable
    let logger: NetworkLoggable
    let session: URLSessionProtocol
    let urlSessionCache: (any NetworkResponseCacheable)?

    init(config: APIConfigurable,
         session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.default), // TODO: could be added another init with configuration
         logger: NetworkLoggable = DefaultNetworkLogger(),
         urlSessionCache: (any NetworkResponseCacheable)? = nil) {
        self.config = config
        self.logger = logger
        self.session = session
        self.urlSessionCache = urlSessionCache
    }

    func fetchRequest<Decoder>(endPoint: any EndpointProtocol,
                               decoder: Decoder) async throws -> Decoder.ModelDTO where Decoder: DTODecodable {
        do {
            let request = try endPoint.request(config: config)

            if let response = urlSessionCache?.get(forKey: request) {
                return try await resolveResponse(data: response.data,
                                                 response: response.response,
                                                 decoder: decoder)
            }

            logger.log(request: request)
            let (data, response) = try await session.data(for: request)
            let cachedResponse = CachedURLResponse(response: response,
                                                   data: data)
            urlSessionCache?.set(value: cachedResponse,
                                 forKey: request)
            return try await resolveResponse(data: data,
                                             response: response,
                                             decoder: decoder)
        } catch {
            throw resolveError(error: error)
        }
    }

    func fetchURL<Decoder>(endPoint: any EndpointProtocol,
                           decoder: Decoder) async throws -> Decoder.ModelDTO where Decoder: DTODecodable {
        do {
            let url: URL = try endPoint.url(config: config)
            let (data, response) = try await session.data(from: url)
            return try await resolveResponse(data: data,
                                             response: response,
                                             decoder: decoder)
        } catch {
            throw resolveError(error: error)
        }
    }

    private func resolveResponse<Decoder>(data: Data,
                                          response: URLResponse,
                                          decoder: Decoder) async throws -> Decoder.ModelDTO where Decoder: DTODecodable {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = response.statusCode
        guard (200 ..< 300).contains(statusCode) else {
            throw NetworkError.serverError(code: statusCode)
        }

        logger.log(data: data, statusCode: statusCode)
        return try decoder.decodeDTO(from: data)
    }

    // Posible network erorr strategies
    private func resolveError(error: Error) -> NetworkError {
        if let error = error as? URLError {
            switch error.code {
            case .cancelled:
                return NetworkError.canceled
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .timedOut:
                return NetworkError.retryNeeded(originalError: error)
            default:
                return .generalError(error)
            }
        }

        return .generalError(error)
    }
}
