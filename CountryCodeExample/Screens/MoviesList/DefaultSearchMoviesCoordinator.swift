//
//  MoviesListCoordinator.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import UIKit

typealias MoviesQueryListViewModelDidSelectAction = (MovieQuery) -> Void

protocol MoviesListCoordinatorDependencies {
    func createSearchMoviesViewController(coordinator: MoviewListCoordinator) -> SearchMoviesViewController
    func createMoviesDetailsViewController(movie: Movie) -> UIViewController
    func createMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController
}

protocol MoviewListCoordinator: Coordinator {
    func showMovieDetails(entry: Movie)
    func closeQueriesSuggestions()
    func showQueriesSuggestions(didSelect: @escaping (_ didSelect: MovieQuery) -> Void)
}

class DefaultSearchMoviesCoordinator: MoviewListCoordinator {
    var childCoordinators: [any Coordinator]
    let dependencies: MoviesListCoordinatorDependencies
    private weak var moviesListVC: SearchMoviesViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    var navigationController: UINavigationController

    func start() {
        let vc = dependencies.createSearchMoviesViewController(coordinator: self)
        moviesListVC = vc
        navigationController.pushViewController(vc, animated: false)
    }

    init(childCoordinators: [any Coordinator] = [],
         navigationController: UINavigationController,
         dependencies: MoviesListCoordinatorDependencies) {
        self.childCoordinators = childCoordinators
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func showMovieDetails(entry: Movie) {
        let vc = dependencies.createMoviesDetailsViewController(movie: entry)
        navigationController.pushViewController(vc, animated: true)
    }

    func closeQueriesSuggestions() {
        guard let moviesQueriesSuggestionsVC,
              let moviesListVC,
              let container = moviesListVC.searchSuggesionContainer else {
            return
        }

        moviesQueriesSuggestionsVC.remove()
        container.isHidden = true
    }

    func showQueriesSuggestions(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) {
        guard let moviesListVC,
              moviesQueriesSuggestionsVC == nil,
              let container = moviesListVC.searchSuggesionContainer else {
            return
        }

        let vc = dependencies.createMoviesQueriesSuggestionsListViewController(didSelect: didSelect)

        moviesListVC.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }
}
