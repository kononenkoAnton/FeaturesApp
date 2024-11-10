//
//  MoviesListViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import UIKit

class SearchMoviesViewController: UIViewController, StoryboardInstantiable, AlertableWithAsync {
    private var viewModel: SearchMoviesViewModel!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @MainActor @IBOutlet var searchBarContainer: UIView!

    private weak var tableViewController: MoviesListTableViewController?

    static func create(with viewModel: DefaultSearchMoviesViewModel) -> SearchMoviesViewController {
        let vc = SearchMoviesViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        viewModel.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
           let destinationVC = segue.destination as? MoviesListTableViewController {
            tableViewController = destinationVC
            destinationVC.viewModel = viewModel
        }
    }

    func setupViews() {
        
        // TODO: check why title not visisble
        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        
        self.title = String(localized: LocalizationStrings.search_screen_title.rawValue)
    }

    func bind(to viewModel: SearchMoviesViewModel) {
        viewModel.error?.addObserver(observer: self, observerBlock: didErrorUpdate)
        viewModel.loading.addObserver(observer: self, observerBlock: didLoadingUpdate)
    }

    func didErrorUpdate(alertData: AlertData?) {
        guard let alertData else {
            return
        }

        Task.detached {
            // TODO: Maybe to send completion and return nil for alertData
            await self.showAlert(alertData: alertData)
        }
    }

    func didLoadingUpdate(loadingType: SearchMoviesLoadingType) {
        if loadingType == .screen {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// extension MoviesListViewController: UISearchControllerDelegate {
// }
//
//
