//
//  MoviesListViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

protocol SearchMoviesViewModelDelegate: AnyObject {
    func viewDidLoad()
    func didSelectItem(index: Int)
    func viewDidDisappiear()
    func didUserHandleSearch(query: String)
    func cancelSearch()
    func didLoadNextPage()
    func didPullToRefresh()
}

enum SearchMoviesLoadingType: String {
    case screen
    case nextPage
    case none
}

protocol SearchMoviesViewModelDataSource: AnyObject {
    var data: Observable<[MoviewSearchViewModel]> { get }
    var newPageData: Observable<[MoviewSearchViewModel]> { get }
    var error: Observable<AlertData>? { get }
    var loading: Observable<SearchMoviesLoadingType> { get }
    var posterImageRepository: PosterImageRepository { get }
    var query: Observable<String> { get }
    var hasMorePages: Bool { get }
    var screenTitle: String { get }
    var emptySearchResults: String { get }
    var searchBarPlaceholder: String { get }
}

protocol SearchMoviesViewModel: SearchMoviesViewModelDelegate, SearchMoviesViewModelDataSource {}

class DefaultSearchMoviesViewModel: SearchMoviesViewModel {
    @MainActor var data: Observable<[MoviewSearchViewModel]> = Observable(item: [])
    // Handle changed data to update diffable data source
    @MainActor var newPageData: Observable<[MoviewSearchViewModel]> = Observable(item: [])

    var error: Observable<AlertData>?
    var loading: Observable<SearchMoviesLoadingType> = Observable(item: .screen)
    var query: Observable<String> = Observable(item: "")

    let searchMoviesUseCase: SearchMoviesUseCase
    let posterImageRepository: PosterImageRepository
    let coordinator: MoviewListCoordinator

    private var debouncer: Debouncable?

    // MARK: - Pagination

    var currentPage = 1
    var totalPageCount = 0
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    var screenTitle: String = String(localized: LocalizationStrings.search_screen_title.rawValue)
    var emptySearchResults: String = String(localized: LocalizationStrings.no_search_result.rawValue)
    var searchBarPlaceholder: String = String(localized: LocalizationStrings.search_bar_placeholder.rawValue)
    init(searchMoviesUseCase: SearchMoviesUseCase,
         posterImageRepository: PosterImageRepository,
         coordinator: MoviewListCoordinator) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImageRepository = posterImageRepository
        self.coordinator = coordinator
    }

    func loadMovie(movieQuery: MovieQuery,
                   loadingType: SearchMoviesLoadingType) {
        query.setItem(movieQuery.query)
        loading.setItem(loadingType)

        print("Loading: <\(loadingType.rawValue)> page:\(nextPage) and query: \(query), totalPages: \(totalPageCount)")
        Task(priority: .userInitiated) {
            do {
                try await Task.sleep(seconds: 2)
                let movie = try await searchMoviesUseCase.execute(useCaseRequest: .init(query: movieQuery, page: nextPage))
                totalPageCount = movie.totalPages
                currentPage = movie.page
                await appendPage(results: movie.results)
                loading.setItem(.none)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }

    @MainActor func appendPage(results: [Movie]) {
        let mappedValues = results.map({ movie in
            MoviewSearchViewModel(title: movie.title,
                                  overview: movie.overview,
                                  posterPath: movie.posterPath,
                                  posterImageRepository: posterImageRepository)
        })

        newPageData.setItem(mappedValues)
        data.setItem(data.item + mappedValues)
    }
}

// MARK: - Delegation from Movies List View Controller

extension DefaultSearchMoviesViewModel {
    func viewDidLoad() {
        loadMovie(movieQuery: .init(query: "war"),
                  loadingType: .screen)
    }

    func didSelectItem(index: Int) {
        // TODO: select item and present details
    }

    func viewDidDisappiear() {
        searchMoviesUseCase.cancel()
    }

    // TODO: Handle no data on search
    func didUserHandleSearch(query: String) {
        guard loading.item == .none else {
            return
        }

        if debouncer == nil {
            debouncer = DefaultDebouncer()
        }

        debouncer?.call {
            Task { @MainActor [weak self] in
                guard let self else { return }
                resetPages()
                loadMovie(movieQuery: .init(query: query),
                          loadingType: .screen)
                debouncer = nil
            }
        }
    }

    func cancelSearch() {
        searchMoviesUseCase.cancel()
    }

    func didLoadNextPage() {
        guard hasMorePages,
              loading.item == .none else { return }
        loading.setItem(.nextPage)

        loadMovie(movieQuery: .init(query: query.item),
                  loadingType: .nextPage)
    }

    func didPullToRefresh() {
        guard loading.item == .none else {
            return
        }

        Task { @MainActor in
            resetPages()
            loadMovie(movieQuery: .init(query: query.item),
                      loadingType: .screen)
        }
    }

    @MainActor private func resetPages() {
        currentPage = 1
        totalPageCount = 0
        data.item.removeAll()
        newPageData.item.removeAll()
    }
}
