//
//  MoviesListViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import UIKit

class SearchMoviesViewController: UIViewController, StoryboardInstantiable, AlertableWithAsync {
    private var viewModel: SearchMoviesViewModel!

    @IBOutlet weak var emptySearchResults: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchSuggesionContainer: UIView!

    @MainActor @IBOutlet var searchBarContainer: UIView!

    private weak var tableViewController: MoviesListTableViewController?
    private lazy var searchController = UISearchController(searchResultsController: nil)

    static func create(with viewModel: DefaultSearchMoviesViewModel) -> SearchMoviesViewController {
        let vc = SearchMoviesViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        viewModel.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        setupBehaviors()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
           let destinationVC = segue.destination as? MoviesListTableViewController {
            tableViewController = destinationVC
            destinationVC.viewModel = viewModel
        }
    }

    fileprivate func setupViews() {
        title = viewModel.screenTitle
        emptySearchResults.isHidden = true
        emptySearchResults.text = viewModel.emptySearchResults
        setupSearchController()
    }

    fileprivate func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)

//        searchController.searchBar.scopeButtonTitles = ["All", "Favorites", "Recent"]

        definesPresentationContext = true
//        searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
    }

    fileprivate func setupBehaviors() {
        addBehaviors([BlackStyleNavigationBarBehavior()])
    }

    fileprivate func bind(to viewModel: SearchMoviesViewModel) {
        viewModel.alerData.addObserver(observer: self, observerBlock: didAlertUpdate)
        viewModel.loading.addObserver(observer: self, observerBlock: didLoadingUpdate)
        viewModel.query.addObserver(observer: self, observerBlock: updateSearchQuery)
        viewModel.data.addObserver(observer: self, observerBlock: didDataUpdate)
    }

    fileprivate func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }

        viewModel.showQueriesSuggestions()
    }

    func didAlertUpdate(alertData: AlertData?) {
        guard let alertData else {
            return
        }

        Task.detached {
            // TODO: Maybe to send completion and return nil for alertData
            await self.showAlert(alertData: alertData)
        }
    }

    func didLoadingUpdate(loadingType: SearchMoviesLoadingType?) {
        if loadingType == .screen {
            activityIndicator.startAnimating()
            emptySearchResults.isHidden = true

        } else {
            activityIndicator.stopAnimating()
        }

        updateQueriesSuggestions()
    }

    func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    func didDataUpdate(data: [MoviewSearchViewModel] = []) {
        emptySearchResults.isHidden = data.count != 0
    }
}

extension SearchMoviesViewController: UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchController.isActive = false
        viewModel.didUserHandleSearch(query: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch()
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

//    public func willDismissSearchController(_ searchController: UISearchController) {
//        updateQueriesSuggestions()
//    }
    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              query.count > 0 else {
            return
        }

        // Handle search with delay if user typing
//        viewModel.didUserHandleSearch(query: query)
    }
}
