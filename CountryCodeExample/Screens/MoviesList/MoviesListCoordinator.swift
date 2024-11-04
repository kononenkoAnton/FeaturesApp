//
//  MoviesListCoordinator.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import UIKit


protocol MoviesListCoordinatorDependencies {
    func createMoviesListViewController(coordinator: MoviewListCoordinatorProtocol) -> MoviesListViewController
}

protocol MoviewListCoordinatorProtocol: Coordinator {
    func showMovieDetails(entry: Movie)
}

class MoviesListCoordinator: MoviewListCoordinatorProtocol {
    var childCoordinators: [any Coordinator]
    let dependencies: MoviesListCoordinatorDependencies
    private weak var moviesListVC: MoviesListViewController?

    var navigationController: UINavigationController

    func start() {
        let vc = dependencies.createMoviesListViewController(coordinator: self)
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

