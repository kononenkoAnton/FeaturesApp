//
//  MoviewsScreenDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

class SearchMoviesScreenDIContainer: MoviesListCoordinatorDependencies {
    let posterImageRequestBuilder: RequestBuilder
    let apiRequestBuilder: RequestBuilder

    init(apiRequestBuilder: RequestBuilder,
         posterImageRequestBuilder: RequestBuilder) {
        self.apiRequestBuilder = apiRequestBuilder
        self.posterImageRequestBuilder = posterImageRequestBuilder
    }

    // MARK: - Repositories

    func createSearchMoviesRepository() -> SearchMoviewRepository {
        DefaultSearchMoviesRepository(networkService: DefaultNetworkService(),
                                      requestBuilder: apiRequestBuilder) // TODO: add cache
    }

    func createPosterImageRepository() -> PosterImageRepository {
        DefaultPosterImageRepository(networkService: DefaultNetworkService(),
                                     requestBuilder: posterImageRequestBuilder)
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
                                     posterImageRepository: createPosterImageRepository(),
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
