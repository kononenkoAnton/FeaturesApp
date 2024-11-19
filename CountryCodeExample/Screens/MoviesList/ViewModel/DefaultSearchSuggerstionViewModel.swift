//
//  SearchSuggerstionViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/16/24.
//

import Combine

protocol SearchSuggerstionViewModelDelegate {
    func viewWillAppear()
    func didSelectItem(index: MovieQuery)
}

protocol SearchSuggerstionViewModelDataSource {
    var items: [MovieQuery] { get }
    var itemsPublisher: AnyPublisher<[MovieQuery], Never> { get }
}

protocol SearchSuggerstionViewModelProtocol: SearchSuggerstionViewModelDelegate, SearchSuggerstionViewModelDataSource {}

typealias FetchRecentMovieQueriesUseCaseFactory = (DefaultFetchRecentMovieQueriesUseCase.RequestValue) -> FetchRecentMovieQueriesUseCase

class DefaultSearchSuggerstionViewModel: SearchSuggerstionViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    private var numberOfQueriesToShow: Int
    private var fetchRecentMovieQueriesUseCaseFactory: FetchRecentMovieQueriesUseCaseFactory
    var didSelect: MoviesQueryListViewModelDidSelectAction

    init(didSelect: @escaping MoviesQueryListViewModelDidSelectAction,
         numberOfQueriesToShow:Int,
         fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory) {
        self.didSelect = didSelect
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentMovieQueriesUseCaseFactory = fetchRecentMovieQueriesUseCaseFactory
    }

    @Published var items: [MovieQuery] = []
    var itemsPublisher: AnyPublisher<[MovieQuery], Never> {
        $items.eraseToAnyPublisher()
    }

    private func updateMoviesQueries() {
        Task(priority: .userInitiated) {
            let request = DefaultFetchRecentMovieQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
            items = await fetchRecentMovieQueriesUseCaseFactory(request).execute()
            print(items)
        }
    }

    func viewWillAppear() {
        updateMoviesQueries()
    }

    func didSelectItem(index: MovieQuery) {
//        didSelect?(MovieQuery(query: item.query))
    }
}
