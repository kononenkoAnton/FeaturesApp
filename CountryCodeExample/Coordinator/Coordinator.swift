//
//  Coordinator.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

protocol Coordinatable: AnyObject {
    var coordinator: Coordinator? { get set}
}
