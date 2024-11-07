//
//  MoviewsScreenDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

class SearchMoviesScreenDIContainer: MoviesListCoordinatorDependencies {
    let imageNetworkService: NetworkServiceProtocol
    let apiNetworkService: NetworkServiceProtocol

    init(apiNetworkService: NetworkServiceProtocol, imageNetworkService: NetworkServiceProtocol) {
        self.apiNetworkService = apiNetworkService
        self.imageNetworkService = imageNetworkService
    }

    // MARK: - Repositories

    func createSearchMoviesRepository() -> SearchMoviewRepository {
        DefaultSearchMoviesRepository(networkService: apiNetworkService) // TODO: add cache
    }

    func createThumbnailsImageRepository() -> ThumbnailImageRepositoryProtocol {
        ThumbnailImageRepository(networkService: imageNetworkService)
    }

    // MARK: - Use case

    func createSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(manager: DefaultSearchMoviesManager(repository: createSearchMoviesRepository()))
    }

    // MARK: - ViewModel

    func createSearchMoviesViewModel(coordinator: MoviewListCoordinator) -> DefaultSearchMoviesViewModel {
        DefaultSearchMoviesViewModel(searchMoviesUseCase: createSearchMoviesUseCase(),
                                     coordinator: coordinator)
    }

    // MARK: - ViewController

    func createSearchMoviesViewController(coordinator: MoviewListCoordinator) -> SearchMoviesViewController {
        SearchMoviesViewController.create(with: createSearchMoviesViewModel(coordinator: coordinator))
    }

    // MARK: - Coordinator

    func createSearchMoviesCoordinator(navigationController: UINavigationController) -> DefaultSearchMoviesCoordinator {
        DefaultSearchMoviesCoordinator(navigationController: navigationController, dependencies: self)
    }
}