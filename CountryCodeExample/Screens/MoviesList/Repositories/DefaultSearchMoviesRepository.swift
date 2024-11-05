//
//  MoviesListRepository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

protocol SearchMoviewRepository {
    func searchMovies(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch
}

class DefaultSearchMoviesRepository: SearchMoviewRepository {
    // TODO: Cache here

    let networkService: any NetworkServiceProtocol
    let mapper: MoviewSearchDTOMapper

    init(networkService: any NetworkServiceProtocol,
         mapper: MoviewSearchDTOMapper = MoviewSearchDTOMapper()) {
        self.networkService = networkService
        self.mapper = mapper
    }

    func searchMovies(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch {
        let useCaseRequestDTO = SearchQueryUseCaseRequestDTOMapper().mapToDTO(from: useCaseRequest)
        let endpoint = try APIStorage.searchMoviesEndpoint(useCaseRequestDTO: useCaseRequestDTO)
        let feedDTO = try await networkService.fetchRequest(endPoint: endpoint,
                                                            decoder: MoviewSearchDTODecoder())
        let feed = mapper.mapToDomain(from: feedDTO)
        return feed
    }
}
