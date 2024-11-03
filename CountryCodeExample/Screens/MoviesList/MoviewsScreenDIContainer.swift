//
//  MoviewsScreenDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

class MoviewsScreenDIContainer {
    let imageNetworkService: NetworkServiceProtocol
    let apiNetworkService: NetworkServiceProtocol

    init(apiNetworkService: NetworkServiceProtocol, imageNetworkService: NetworkServiceProtocol) {
        self.apiNetworkService = apiNetworkService
        self.imageNetworkService = imageNetworkService
    }

    // Mark Repositories

    func createMoviesRepository() -> MoviesListRepositoryProtocol {
        MoviesListRepository(networkService: apiNetworkService) // TODO: add cache
    }

    func createThumbnailsImageRepository() -> ThumbnailImageRepositoryProtocol {
        ThumbnailImageRepository(networkService: imageNetworkService)
    }
}
