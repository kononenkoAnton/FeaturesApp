//
//  NetworkServiceProtocol.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//



enum NetworkError: Error {
    case serverError(code: Int)
    case networkEror
    case invalidResponse
    case timeout
    case canceled
    case generalError(Error)

    var localizedDescription: String {
        switch self {
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


protocol NetworkServiceProtocol {
    associatedtype Parsable: JSONParsable
    func fetchRequest(endPoint: EndpointProtocol,
                      parser: Parsable) async throws -> Parsable.Model?
    func fetchURL(endPoint: EndpointProtocol,
                  parser: Parsable) async throws -> Parsable.Model?
}
