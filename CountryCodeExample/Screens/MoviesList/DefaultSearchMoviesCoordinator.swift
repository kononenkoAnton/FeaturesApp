//
//  MoviesListCoordinator.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import UIKit


protocol MoviesListCoordinatorDependencies {
    func createSearchMoviesViewController(coordinator: MoviewListCoordinator) -> SearchMoviesViewController
}

protocol MoviewListCoordinator: Coordinator {
    func showMovieDetails(entry: Movie)
}

class DefaultSearchMoviesCoordinator: MoviewListCoordinator {
    var childCoordinators: [any Coordinator]
    let dependencies: MoviesListCoordinatorDependencies
    private weak var moviesListVC: SearchMoviesViewController?

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
        // TODO: Implement details
    }
}

