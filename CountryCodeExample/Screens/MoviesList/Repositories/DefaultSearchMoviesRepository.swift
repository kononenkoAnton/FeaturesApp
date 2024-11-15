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
    let requestBuilder: RequestBuilder
    
    init(networkService: any NetworkServiceProtocol,
         requestBuilder: RequestBuilder,
         mapper: MoviewSearchDTOMapper = MoviewSearchDTOMapper()) {
        self.networkService = networkService
        self.mapper = mapper
        self.requestBuilder = requestBuilder
    }

    func searchMovies(useCaseRequest: SearchQueryUseCaseRequest) async throws -> MoviesSearch {
        let endpoint = try APIStorage.searchMoviesEndpoint(useCaseRequest: useCaseRequest)
        let request = try requestBuilder.request(endpoint: endpoint)
        let feedDTO = try await networkService.fetchRequest(request: request,
                                                            decoder: MoviewSearchDTODecoder())
        let feed = mapper.mapToDomain(from: feedDTO)
        return feed
    }
}

