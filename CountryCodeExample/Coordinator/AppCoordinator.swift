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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MoviesListViewController") as? MoviesListViewController else {
            fatalError("MoviesListViewController not found")
        }

        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showDetail() {
//           let detailVC = DetailViewController()
//           detailVC.coordinator = self
//           navigationController.pushViewController(detailVC, animated: true)
    }
}
