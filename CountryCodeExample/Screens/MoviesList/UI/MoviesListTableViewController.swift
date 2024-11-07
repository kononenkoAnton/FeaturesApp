//
//  MoviewListTableViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import UIKit

class MoviesListTableViewController: UITableViewController {
    var viewModel: SearchMoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        tableView.prefetchDataSource = self
        configureDiffableDataSourceSnapshot()
    }

    // MARK: - Public

    func reloadData() {
        tableView.reloadData()
    }

    // MARK: - Private

    var dataSource: UITableViewDiffableDataSource<DefaultSection, SearchMoviewModel>!

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, model -> SearchMovieCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieCell.cellIdentifier, for: indexPath) as? SearchMovieCell else {
                return nil
            }

            cell.updateData(model: model)
            return cell
        }
    }
    
    func configureDiffableDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, SearchMoviewModel>()
        let section = DefaultSection(title: "Movies")
        
        snapshot.appendSections([section])
        snapshot.appendItems([], toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    
    func updateSnapshot(section: DefaultSection) {
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieCell.cellIdentifier, for: indexPath) as! SearchMovieCell

        return cell
    }
}

extension MoviesListTableViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

extension MoviesListTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        updateSnapshot() after 
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
    
    
    
}
