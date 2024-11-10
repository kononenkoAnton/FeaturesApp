//
//  MoviewListTableViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import UIKit

class MoviesListTableViewController: UITableViewController {
    weak var viewModel: SearchMoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        tableView.prefetchDataSource = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try? viewModel.posterImageRepository.cancelLoadAll()
    }

    // MARK: - Public

    func reloadData() {
        configureDiffableDataSourceSnapshot()
        tableView.reloadData()
    }

    // MARK: - Private

    var dataSource: UITableViewDiffableDataSource<DefaultSection, MoviewSearchViewModel>!

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, model -> SearchMovieCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieCell.cellIdentifier,
                                                           for: indexPath) as? SearchMovieCell else {
                return nil
            }

            cell.updateData(model: model)
            return cell
        }
    }

    func configureDiffableDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, MoviewSearchViewModel>()
        let section = DefaultSection(title: "Movies")

        snapshot.appendSections([section])
        snapshot.appendItems(viewModel.data.item, toSection: section)

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
    func cellImageData(for indexPath: IndexPath) -> (viewModel: MoviewSearchViewModel, width: Int)? {
        let dataSource = viewModel.data.item
        guard dataSource.count > indexPath.row else {
            return nil
        }

        let movieSearchViewModel = dataSource[indexPath.row]
        //TODO: change to some better way
        return (movieSearchViewModel, 66)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let (viewModel, width) = cellImageData(for: indexPath) else {
                continue
            }

            if indexPaths.contains(where: isLoadingCell) {
                  loadData(cursor: nextCursor)
              }
            
            Task(priority: .userInitiated) {
                await viewModel.loadImage(width: width)
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let (viewModel, width) = cellImageData(for: indexPath) else {
                continue
            }

            viewModel.cancelLoad(width: width)
        }
    }
}
