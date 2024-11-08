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

    func createPosterImageRepository() -> PosterImageRepository {
        DefaultPosterImageRepository(networkService: imageNetworkService)
    }

    // MARK: - Manager
    func createSearchMoviewManager() -> SearchMoviesManager {
        DefaultSearchMoviesManager(repository: createSearchMoviesRepository())
    }
    
    // MARK: - Use case

    func createSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(manager: createSearchMoviewManager())
    }

    // MARK: - ViewModel

    func createSearchMoviesViewModel(coordinator: MoviewListCoordinator) -> DefaultSearchMoviesViewModel {
        DefaultSearchMoviesViewModel(searchMoviesUseCase: createSearchMoviesUseCase(),
                                     thumbnailImageRepository: createPosterImageRepository(),
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
