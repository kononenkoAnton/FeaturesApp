//
//  NetworkServiceProtocol.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

enum NetworkError: Error {
    case serverError(code: Int)
    case retryNeeded(originalError: Error)
    case invalidResponse
    case canceled
    case generalError(Error)

    var localizedDescription: String {
        switch self {
        case let .serverError(code):
            return "Sever Error- code: \(code)"
        case .invalidResponse:
            return "Invalid Response Error"
        case .canceled:
            return "Canceled"
        case let .retryNeeded(originalError):
            return "Retry needed, original error: \(originalError.localizedDescription)"
        case let .generalError(error):
            return error.localizedDescription
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchRequest<Decoder: DTODecodable>(endPoint: EndpointProtocol,
                                             decoder: Decoder) async throws -> Decoder.ModelDTO
    func fetchURL<Decoder: DTODecodable>(endPoint: EndpointProtocol,
                                         decoder: Decoder) async throws -> Decoder.ModelDTO
}
