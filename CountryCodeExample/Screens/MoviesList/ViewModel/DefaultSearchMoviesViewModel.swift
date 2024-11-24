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
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
}

enum SearchMoviesLoadingType: String {
    case screen
    case nextPage
    case none
}

protocol SearchMoviesViewModelDataSource: AnyObject {
    var data: Observable<[MoviewSearchViewModel]> { get }
    var newPageData: Observable<[MoviewSearchViewModel]> { get }
    var alerData: Observable<AlertData?> { get }
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

    var alerData: Observable<AlertData?> = Observable(item: nil)
    var loading: Observable<SearchMoviesLoadingType> = Observable(item: .none)
    var query: Observable<String> = Observable(item: "")
    private var movies: [Movie] = []

    let searchMoviesUseCase: SearchMoviesUseCase
    let posterImageRepository: PosterImageRepository
    let coordinator: MoviewListCoordinator

    private var debouncer: Debouncable?
    private var rechability: ReachabilityService

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
         coordinator: MoviewListCoordinator,
         rechability: ReachabilityService = DefaultReachablity.shared) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImageRepository = posterImageRepository
        self.coordinator = coordinator
        self.rechability = rechability
        startObserveRechability()
    }

    deinit {
        stopObserveRechability()
    }

    func loadMovie(movieQuery: MovieQuery,
                   loadingType: SearchMoviesLoadingType) {
        query.setItem(movieQuery.query)
        loading.setItem(loadingType)

        print("Loading: <\(loadingType.rawValue)> page:\(nextPage) and query: \(query), totalPages: \(totalPageCount)")
        Task(priority: .userInitiated) {
            do {
                let movie = try await searchMoviesUseCase.execute(useCaseRequest: .init(query: movieQuery, page: nextPage))
                totalPageCount = movie.totalPages
                currentPage = movie.page
                await appendPage(results: movie.results)
                loading.setItem(.none)
            } catch {
                handleError(error: error)
            }
        }
    }

    @MainActor func appendPage(results: [Movie]) {
        // TODO: Check is no duplication
        movies += results
        let mappedValues = results.map({ movie in
            MoviewSearchViewModel(title: movie.title,
                                  overview: movie.overview,
                                  posterPath: movie.posterPath,
                                  posterImageRepository: posterImageRepository)
        })

        newPageData.setItem(mappedValues)
        data.setItem(data.item + mappedValues)
    }

    private func updateError(errorTitle: String = String(localized: LocalizationStrings.alert_error_title.rawValue), errorMessage: String) {
        loading.item = .none
        alerData.item = AlertData(title: errorTitle,
                                  message: errorMessage)
    }
}

// MARK: - Delegation from Movies List View Controller

extension DefaultSearchMoviesViewModel {
    func viewDidLoad() {
    }

    func didSelectItem(index: Int) {
        coordinator.showMovieDetails(entry: movies[index])
    }

    func viewDidDisappiear() {
        searchMoviesUseCase.cancel()
    }

    private func update(movieQuery: MovieQuery) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            resetPages()
            loadMovie(movieQuery: movieQuery, loadingType: .screen)
        }
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

    func showQueriesSuggestions() {
        // Check if not memory leak to pass func like this
        coordinator.showQueriesSuggestions(didSelect: update(movieQuery:))
    }

    func closeQueriesSuggestions() {
        coordinator.closeQueriesSuggestions()
    }
}

extension DefaultSearchMoviesViewModel: ReachabilityObservable {
    func showNoInternetError() {
        updateError(errorTitle: String(localized: LocalizationStrings.alert_error_title.rawValue),
                    errorMessage: String(localized: LocalizationStrings.no_internet_connection.rawValue))
    }

    func showGeneralError() {
        updateError(errorTitle: String(localized: LocalizationStrings.alert_error_title.rawValue),
                    errorMessage: String(localized: LocalizationStrings.loading_issue_message.rawValue))
    }

    func didReachabilityChange(to type: ReachabilityStatus) {
        switch type {
        case .noInternet:
            showNoInternetError()
        case .reachable:
            break
        case .restricted:
            break
        default:
            break
        }
    }

    func startObserveRechability() {
        rechability.addObserver(self)
    }

    func stopObserveRechability() {
        rechability.removeObserver(self)
    }
}

extension DefaultSearchMoviesViewModel {
    func handleError(error: Error) {
        switch error {
        case let SearchMoviesManagerError.retriesFailed(originalError: error):
            if rechability.currentStatus == .noInternet {
                showNoInternetError()
            } else {
                showGeneralError()
            }
        default:
            showGeneralError()
        }
    }
}
