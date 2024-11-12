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
    func didUserHandleSearch(useCaseRequest: SearchQueryUseCaseRequest)
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

    // MARK: - Pagination

    var currentPage = 1
    var totalPageCount = 0
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    var screenTitle: String = String(localized: LocalizationStrings.search_screen_title.rawValue)
    var emptySearchResults: String = String(localized: LocalizationStrings.no_search_result.rawValue)
    
    init(searchMoviesUseCase: SearchMoviesUseCase,
         posterImageRepository: PosterImageRepository,
         coordinator: MoviewListCoordinator) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImageRepository = posterImageRepository
        self.coordinator = coordinator
    }

    func loadMovie(useCaseRequest: SearchQueryUseCaseRequest, loadingType: SearchMoviesLoadingType) {
        query.setItem(useCaseRequest.query)
        loading.setItem(loadingType)

        print("Loading: <\(loadingType.rawValue)> page:\(useCaseRequest.page) and query: \(query), totalPages: \(totalPageCount)")
        Task(priority: .userInitiated) {
            do {
                let movie = try await searchMoviesUseCase.execute(useCaseRequest: useCaseRequest)
//                totalPageCount = movie.totalPages
                totalPageCount = 2
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

        data.setItem(mappedValues)
        data.setItem(data.item + mappedValues)
    }
}

// MARK: - Delegation from Movies List View Controller

extension DefaultSearchMoviesViewModel {
    func viewDidLoad() {
        loadMovie(useCaseRequest: .init(query: "war", page: nextPage),
                  loadingType: .screen)
    }

    func didSelectItem(index: Int) {
        // TODO: select item and present details
    }

    func viewDidDisappiear() {
        searchMoviesUseCase.cancel()
    }

    func didUserHandleSearch(useCaseRequest: SearchQueryUseCaseRequest) {
        Task(priority: .userInitiated) {
            do {
                let feed = try await searchMoviesUseCase.execute(useCaseRequest: useCaseRequest)
                print(feed)
            } catch {
                print(error)
            }
        }
    }

    func didLoadNextPage() {
        guard hasMorePages,
              loading.item == .none else { return }
        loading.setItem(.nextPage)

        loadMovie(useCaseRequest: .init(query: query.item, page: nextPage),
                  loadingType: .nextPage)
    }

    func didPullToRefresh() {
        guard loading.item == .none else {
            return
        }
        
        Task { @MainActor in
            resetPages()
            loadMovie(useCaseRequest: SearchQueryUseCaseRequest(query: query.item, page: 1),
                      loadingType: .none)
        }
        
    }
    
    @MainActor private func resetPages() {
        currentPage = 1
        totalPageCount = 0
        data.item.removeAll()
        newPageData.item.removeAll()
    }
}
