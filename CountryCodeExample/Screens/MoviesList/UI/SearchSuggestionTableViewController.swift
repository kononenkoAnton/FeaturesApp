//
//  SearchSuggestionTableViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/16/24.
//

import Combine
import UIKit

class SearchSuggestionTableViewController: UITableViewController, StoryboardInstantiable {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: SearchSuggerstionViewModelProtocol!

    static func create(with viewModel: SearchSuggerstionViewModelProtocol) -> SearchSuggestionTableViewController {
        let viewController = SearchSuggestionTableViewController.instantiateViewController()
        viewController.viewModel = viewModel

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindData(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    func setupTableView() {
        configureDataSource()
        updateSnapshot()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = SearchSuggestionCell.cellHeight
        tableView.rowHeight = UITableView.automaticDimension
    }

    func bindData(to viewModel: SearchSuggerstionViewModelProtocol) {
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self else { return }
                updateSnapshot(with: items)
            }
            .store(in: &cancellables)
    }

    var dataSource: UITableViewDiffableDataSource<DefaultSection, MovieQuery>?
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> SearchSuggestionCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionCell.cellIdentifier, for:indexPath) as? SearchSuggestionCell else {
                return nil
            }

            cell.updateData(model: model)
            return cell
        })
    }

    func updateSnapshot(with items: [MovieQuery] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, MovieQuery>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Table view data source

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(index: indexPath.row)
    }
}
