//
//  BooksSceneDIContainer.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import UIKit

final class BooksSceneDIContainer: BooksSceneFlowCordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Manager Dependencies
    
    func makeSearchBooksUseCase() -> SearchBooksUseCase {
        BookListManager(
            booksRepository: makeBooksRepository()
        )
    }
    
    // MARK: - Repository Dependencies
    
    func makeBooksRepository() -> BooksListProtocol {
        BookListRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    
    // MARK: - Books List Dependencies
    
    func makeBookListViewController(_ actions: BooksListViewModelActions) -> ViewController {
        ViewController.create(with: makeBooksListViewModel(with: actions))
    }
    
    func makeBooksListViewModel(with actions: BooksListViewModelActions) -> BookListViewModelProtocol {
        DefaultBookListViewModel(searchBooksManager: makeSearchBooksUseCase(), actions: actions)
    }
    
    // MARK: - Books Detail Dependencies
    
    func makeBookDetailViewController(book: Book) -> UIViewController {
        return BookDetailViewController.create(with: makeMoviesDetailViewModel(book: book))
    }
    
    func makeMoviesDetailViewModel(book: Book) -> BookDetailViewModel {
        return BookDetailViewModel(bookDetail: book)
    }
    
    // MARK: - Books Query Suggestion Dependencies
    
    func makeBooksQueriesSuggestionsListViewController() -> UIViewController {
        return UIViewController()
    }
    
    
}

extension BooksSceneDIContainer {
    
    // MARK: - Flow Coordinators
    func makeBooksSearchFlowCoordinator(navigationController: UINavigationController) -> BooksSearchFlowCoordinator {
        BooksSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
