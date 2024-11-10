//
//  MoviesListViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

protocol SearchMoviesViewModelDelegate: AnyObject {
    func viewDidLoad()
    func didSelectItem(index: Int)
    func viewDidDisappiear()
    func didUserHandleSearch(useCaseRequest: SearchQueryUseCaseRequest)
}

protocol SearchMoviesViewModelDataSource: AnyObject {
    var data: Observable<[MoviewSearchViewModel]> { get }
    var error: Observable<AlertData>? { get }
    var loading: Observable<Bool> { get }
    var posterImageRepository: PosterImageRepository { get }
}

protocol SearchMoviesViewModel: SearchMoviesViewModelDelegate, SearchMoviesViewModelDataSource {}

class DefaultSearchMoviesViewModel: SearchMoviesViewModel {
    @MainActor var data: Observable<[MoviewSearchViewModel]> = Observable(item: [])
    @MainActor var error: Observable<AlertData>?
    @MainActor var loading: Observable<Bool> = Observable(item: true)

    let searchMoviesUseCase: SearchMoviesUseCase
    let posterImageRepository: PosterImageRepository
    let coordinator: MoviewListCoordinator

    init(searchMoviesUseCase: SearchMoviesUseCase,
         posterImageRepository: PosterImageRepository,
         coordinator: MoviewListCoordinator) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImageRepository = posterImageRepository
        self.coordinator = coordinator
    }
}

// MARK: - Delegation from Movies List View Controller

extension DefaultSearchMoviesViewModel {
    func viewDidLoad() {
        Task(priority: .userInitiated) {
            do {
                let movie = try await searchMoviesUseCase.execute(useCaseRequest: SearchQueryUseCaseRequest(query: "war", page: 1))
                let mappedValues = movie.results[0...7].map({ movie in
                    MoviewSearchViewModel(title: movie.title,
                                          overview: movie.overview,
                                          posterPath: movie.posterPath,
                                          posterImageRepository: posterImageRepository)
                })

                await data.setItem(mappedValues)
                await loading.setItem(false)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
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
}
