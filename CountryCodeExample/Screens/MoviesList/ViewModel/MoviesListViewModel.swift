//
//  MoviesListViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

protocol MoviesListViewControllerDelegate {
    func viewDidLoad()
    func didSelectItem(index: Int)
    func viewDidDisappiear()
}

protocol MoviesListViewModelDataSource {
    
}

protocol MoviesListViewModelProtocol: MoviesListViewControllerDelegate, MoviesListViewModelDataSource {}

class MoviesListViewModel: MoviesListViewModelProtocol {
    let moviewListManager: MoviesListManagerProtocol
    let coordinator: MoviewListCoordinatorProtocol

    init(moviewListManager: MoviesListManagerProtocol,
         coordinator: MoviewListCoordinatorProtocol) {
        self.moviewListManager = moviewListManager
        self.coordinator = coordinator
    }
}

// MARK: - Delegation from Movies List View Controller

extension MoviesListViewModel {
    func viewDidLoad() {
        Task {
            do {
                let feed = try await moviewListManager.loadMoviewList()
            } catch {
                // Handle heigh level errors
            }
            
        }
        
    }

    func didSelectItem(index: Int) {
        //TODO: select item and present details
    }

    func viewDidDisappiear() {
        moviewListManager.cancel()
    }
}

// MARK: - Data Sources for MoviewViewController

extension MoviesListViewModel {
}
