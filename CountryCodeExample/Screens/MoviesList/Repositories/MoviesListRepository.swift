//
//  MoviesListRepository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

protocol MoviesListRepositoryProtocol {
    func loadMovilesList() async throws -> Feed
}

class MoviesListRepository: MoviesListRepositoryProtocol {
    // TODO: Cache here

    let networkService: any NetworkServiceProtocol
    let mapper: FeedDTOMapper

    init(networkService: any NetworkServiceProtocol,
         mapper: FeedDTOMapper = FeedDTOMapper()) {
        self.networkService = networkService
        self.mapper = mapper
    }

    func loadMovilesList() async throws -> Feed {
        let endpoint = APIStorage.MoviesScreen.moviesListEndpoint(path: "movieFeedv2.json")
        let feedDTO = try await networkService.fetchRequest(endPoint: endpoint,
                                                            decoder: FeedDTODecoder())
        let feed = mapper.mapToDomain(from: feedDTO)
        return feed
    }
}
