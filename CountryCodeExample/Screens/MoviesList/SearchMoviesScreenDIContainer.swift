//
//  MoviewsScreenDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

// enum PreferredPersistStorage {
//    case userDefaults
//    case file
//    case sqlite
//    case coreData
// }

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

    func createQueryRepository() -> MoviesQueryRepository {
        DefaultMoviesQueryReository(storage: createQueryStorage())
    }

    // MARK: - Manager

    func createSearchMoviewManager() -> SearchMoviesManager {
        DefaultSearchMoviesManager(repository: createSearchMoviesRepository())
    }

    // MARK: - Use Case

    func createSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(manager: createSearchMoviewManager(),
                                   queryRepository: createQueryRepository())
    }

    // MARK: - Storage

    // TODO: Resolve problem to device this func on two func and decide something with non sendable Filemanager or UserDefaults
    func createQueryStorage() -> MoviesQueriesStorage {
        let fileManager = FileManager.default
        guard let cacheFolderURL = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first else {
            fatalError("Can not create cache folder URL")
        }

        let cacheFolderTitle = String(describing: DefaultFileBasedCache<[MovieQuery], String>.self)
        let cacheURLFolder = cacheFolderURL.appendingPathComponent(cacheFolderTitle)
        let fileBaseCache = DefaultFileBasedCache<[MovieQuery], String>(cacheURLFolder: cacheURLFolder)

        return DefaultMovieQueriesStorage(cache: fileBaseCache)
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
