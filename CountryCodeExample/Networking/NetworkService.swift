//
//  NetworkService.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

enum NetworkError: Error {
    case parsingError
    case serverError(code: Int)
    case networkEror
    case invalidResponse
    case timeout
    case canceled
    case generalError(Error)

    var localizedDescription: String {
        switch self {
        case .parsingError:
            return "Parsing Error"
        case let .serverError(code):
            return "Sever Error- code: \(code)"
        case .networkEror:
            return "Network Error"
        case .invalidResponse:
            return "Invalid Response Error"
        case .timeout:
            return "Timeout Error"
        case .canceled:
            return "Canceled"
        case let .generalError(error):
            return error.localizedDescription
        }
    }
}

protocol JSONParsable: Codable {
    associatedtype Model
    func parse(data: Data) throws -> Model
}

protocol NetworkFetchable {
    associatedtype Parsable: JSONParsable
    func fetchRequest(endPoint: EndpointProtocol,
                      parser: Parsable) async throws -> Parsable.Model?
    func fetchURL(endPoint: EndpointProtocol,
                  parser: Parsable) async throws -> Parsable.Model?
}

class DefaultNetworkService<Parser: JSONParsable>: NetworkFetchable {
    typealias Parsable = Parser
    // TODO: Add logger, error, response, request
    let config: APIConfigurable
    let logger: NetworkLoggable
    let session: URLSessionProtocol
    init(config: APIConfigurable,
         session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.default),
         logger: NetworkLoggable = DefaultNetworkLogger()) {
        self.config = config
        self.logger = logger
        self.session = session
    }

    func fetchRequest(endPoint: any EndpointProtocol,

                      parser: Parser) async throws -> Parsable.Model? {
        do {
            let request = try endPoint.request(config: config)
            logger.log(request: request)
            let (data, response) = try await session.data(for: request)
            return try resolveResponse(data: data, response: response, parser: parser)
        } catch {
            throw resolveError(error: error)
        }
    }

    func fetchURL(endPoint: any EndpointProtocol,
                  parser: Parser) async throws -> Parsable.Model? {
        do {
            let url: URL = try endPoint.url(config: config)
            let (data, response) = try await session.data(from: url)
            return try resolveResponse(data: data, response: response, parser: parser)
        } catch {
            throw resolveError(error: error)
        }
    }

    private func resolveResponse(data: Data,
                                 response: URLResponse,
                                 parser: Parser) throws -> Parsable.Model {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = response.statusCode
        guard (200 ..< 300).contains(statusCode) else {
            throw NetworkError.serverError(code: statusCode)
        }

        logger.log(data: data, statusCode: statusCode)
        return try parser.parse(data: data)
    }

    private func resolveError(error: Error) -> NetworkError {
        if let error = error as? URLError {
            switch error.code {
            case .cancelled:
                return NetworkError.canceled
            case .notConnectedToInternet, .networkConnectionLost:
                return NetworkError.networkEror
            case .timedOut:
                return NetworkError.timeout
            default:
                return .generalError(error)
            }
        }

        if let error = error as? RequestError,
           case .canNotCreateURL = error {
            return NetworkError.parsingError
        }

        return .generalError(error)
    }
}
