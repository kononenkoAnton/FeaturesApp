//
//  MoviesListRepository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

protocol MoviesListRepositoryProtocol {
    func loadMovilesList(endpoint: Endpoint) async throws -> [Entry]
}

class MoviesListRepository {
    // TODO: Cache here

    let networkService: any NetworkServiceProtocol

    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func loadMovilesList(endpoint: Endpoint) async throws -> [Entry] {
//        let feed = networkService.fetchRequest(endPoint: endpoint,
//                                               parser: <#T##any NetworkServiceProtocol.Parsable#>)
    }
}
