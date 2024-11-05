//
//  ContriesListCoordinator.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let moviewSceneDIContainer = appDIContainer.getMoviesListDIContainer()
        let coordinator = moviewSceneDIContainer.createSearchMoviesCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
