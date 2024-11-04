//
//  MoviesListViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import UIKit

class MoviesListViewController: UIViewController, StoryboardInstantiable, AlertableWithAsync {
    var viewModel: MoviesListViewModelProtocol!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchBarContainer: UIView!

    private weak var tableViewController: MoviesListTableViewController?

    static func create(with viewModel: MoviesListViewModel) -> MoviesListViewController {
        let vc = MoviesListViewController.instantiateViewController()
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
        navigationController?.title = "The Movies"
    }

    func bind(to viewModel: MoviesListViewModelProtocol) {
        viewModel.entry.addObserver(observer: self, observerBlock: didEntryUpdate)
        viewModel.error?.addObserver(observer: self, observerBlock: didErrorUpdate)
        viewModel.loading.addObserver(observer: self, observerBlock: didLoadingUpdate)
    }

    func didEntryUpdate(entry: [Movie]) {
        tableViewController?.reloadData()
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

    func didLoadingUpdate(loading: Bool) {
        loading ?
            activityIndicator.startAnimating() :
            activityIndicator.stopAnimating()
    }
}

// extension MoviesListViewController: UISearchControllerDelegate {
// }
//
//
