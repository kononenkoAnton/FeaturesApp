//
//  MoviesListViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import UIKit

class MoviesListViewController: UIViewController, StoryboardInstantiable {
    weak var coordinator: MoviewListCoordinatorProtocol?
    var viewModel: MoviesListViewModel!
    
    static func create(with viewModel: MoviesListViewModel) -> MoviesListViewController  {
        let vc = MoviesListViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
}

