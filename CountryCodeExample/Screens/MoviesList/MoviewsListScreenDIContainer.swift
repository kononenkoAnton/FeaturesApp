//
//  MoviewsScreenDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

class MoviewsListScreenDIContainer: MoviesListCoordinatorDependencies {
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

    // Scene

    func createMoviesListViewController() -> MoviesListViewController {
        MoviesListViewController.create(with: createMoviesListViewModel())
    }

    func createMoviesListViewModel() -> MoviesListViewModel {
        MoviesListViewModel()
    }

    func createMoviesListCoordinator(navigationController: UINavigationController) -> MoviesListCoordinator {
        MoviesListCoordinator(navigationController: navigationController, dependencies: self)
    }
}
