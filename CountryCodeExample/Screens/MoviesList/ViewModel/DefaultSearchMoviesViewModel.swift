//
//  MoviesListViewModel.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

protocol SearchMoviesViewModelDelegate {
    func viewDidLoad()
    func didSelectItem(index: Int)
    func viewDidDisappiear()
    func didUserHandleSearch(useCaseRequest: SearchQueryUseCaseRequest)
}

protocol SearchMoviesViewModelDataSource {
    var entry: Observable<[Movie]> { get }
    var error: Observable<AlertData>? { get }
    var loading:Observable<Bool> { get }
}

protocol SearchMoviesViewModel: SearchMoviesViewModelDelegate, SearchMoviesViewModelDataSource {}

class DefaultSearchMoviesViewModel: SearchMoviesViewModel {
    var entry: Observable<[Movie]> = Observable(item: [])
    var error: Observable<AlertData>?
    var loading:Observable<Bool> = Observable(item: true)

    let searchMoviesUseCase: SearchMoviesUseCase
    let thumbnailImageRepository: PosterImageRepository
    let coordinator: MoviewListCoordinator

    init(searchMoviesUseCase: SearchMoviesUseCase,
         thumbnailImageRepository: PosterImageRepository,
         coordinator: MoviewListCoordinator) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.thumbnailImageRepository = thumbnailImageRepository
        self.coordinator = coordinator
    }
}

// MARK: - Delegation from Movies List View Controller

extension DefaultSearchMoviesViewModel {
    func viewDidLoad() {
      
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
