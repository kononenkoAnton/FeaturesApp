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
        setupTableView()
        setupRefreshControl()
        bind(to: viewModel)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try? viewModel.posterImageRepository.cancelLoadAll()
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.prefetchDataSource = self
        tableView.delegate = self
        configureDataSource()
        makeEmptySnapshot()
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: String(localized: LocalizationStrings.pull_to_refresh.rawValue))
        refreshControl?.addTarget(self, action: #selector(performPullToRefresh), for: .valueChanged)
    }

    @objc private func performPullToRefresh() {
        makeEmptySnapshot()
        viewModel.didPullToRefresh()
    }

    private func bind(to viewModel: SearchMoviesViewModel) {
        viewModel.loading.addObserver(observer: self, observerBlock: didLoadingUpdate)
        viewModel.data.addObserver(observer: self, observerBlock: didNewPageDataRecieve)
    }

    private func didNewPageDataRecieve(newPageData: [MoviewSearchViewModel]) {
        refreshControl?.endRefreshing()
        appendNewPageDataToSnapshot(with: newPageData)
    }

    private func didLoadingUpdate(loadingType: SearchMoviesLoadingType) {
        if loadingType == .nextPage {
            showLoadingFooter()
            return
        } else if loadingType == .screen {
            makeEmptySnapshot()
        }

        hideLoadingFooter()
    }

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

    func makeEmptySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, MoviewSearchViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func appendNewPageDataToSnapshot(with newItems: [MoviewSearchViewModel]) {
        var snapshot = dataSource.snapshot()

        snapshot.appendItems(viewModel.data.item,
                             toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

//    @objc func reloadSnapshotData() {
//        var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, MoviewSearchViewModel>()
//        snapshot.appendItems(viewModel.data.item,
//                             toSection: .main)
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
}

extension MoviesListTableViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        viewModel.didSelectItem(index: indexPath.row)
    }
}

extension MoviesListTableViewController: UITableViewDataSourcePrefetching {
    func handleNextPageRequest() {
        let snapshot = dataSource.snapshot()
        guard snapshot.numberOfItems > 0 else { return }

        if viewModel.hasMorePages {
            viewModel.didLoadNextPage()
        } else if tableView.tableFooterView == nil {
            showNoMorePages(message: String(localized: LocalizationStrings.no_more_data.rawValue))
        }
    }

    func cellImageData(for indexPath: IndexPath) -> (cellViewModel: MoviewSearchViewModel, width: Int)? {
        let dataSource = viewModel.data.item
        guard dataSource.count > indexPath.row else {
            return nil
        }

        let movieSearchViewModel = dataSource[indexPath.row]
        // TODO: change to some better way
        return (movieSearchViewModel, 66)
    }

    func isNeedToLoadNewPage(indexPath: IndexPath) -> Bool {
        let loadNewPageOffset = 5
        return indexPath.row >= viewModel.data.item.count - loadNewPageOffset
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let (cellViewModel, width) = cellImageData(for: indexPath) else {
                continue
            }

            if indexPaths.contains(where: isNeedToLoadNewPage) {
                handleNextPageRequest()
            }

            Task(priority: .userInitiated) {
                await cellViewModel.loadImage(width: width)
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let (cellViewModel, width) = cellImageData(for: indexPath) else {
                continue
            }

            cellViewModel.cancelLoad(width: width)
        }
    }
}

extension MoviesListTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100.0
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - threshold {
            handleNextPageRequest()
        }
    }
}

extension MoviesListTableViewController {
    var footerFrame: CGRect {
        CGRect(x: 0,
               y: 0,
               width: tableView.bounds.width,
               height: 44)
    }

    func showLoadingFooter() {
        let footerView = UIActivityIndicatorView(style: .medium)
        footerView.startAnimating()
        footerView.frame = footerFrame
        tableView.tableFooterView = footerView
    }

    func showNoMorePages(message: String) {
        let footerView = UITableViewHeaderFooterView()
        footerView.frame = footerFrame

        let label = UILabel(frame: footerView.bounds)
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        footerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            label.topAnchor.constraint(equalTo: footerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
        ])

        tableView.tableFooterView = footerView
    }

    func hideLoadingFooter() {
        tableView.tableFooterView = nil
    }
}
