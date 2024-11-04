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
    var entry: Observable<[Movie]> { get }
    var error: Observable<AlertData>? { get }
    var loading:Observable<Bool> { get }
}

protocol MoviesListViewModelProtocol: MoviesListViewControllerDelegate, MoviesListViewModelDataSource {}

class MoviesListViewModel: MoviesListViewModelProtocol {
    var entry: Observable<[Movie]> = Observable(item: [])
    var error: Observable<AlertData>?
    var loading:Observable<Bool> = Observable(item: true)

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
        Task(priority: .userInitiated) {
            do {
                let feed = try await moviewListManager.loadMoviewList()
                print(feed)
            } catch {
                print(error)
            }
        }
    }

    func didSelectItem(index: Int) {
        // TODO: select item and present details
    }

    func viewDidDisappiear() {
        moviewListManager.cancel()
    }
}
