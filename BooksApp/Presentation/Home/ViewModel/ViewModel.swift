//
//  ViewModel.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import Foundation

struct BooksListViewModelActions {
    let showBookDetails: (Book) -> Void
}

enum BookListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol BooksListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didCancelSearch()
    func didSearch(query: String)
    func showQuerySuggestion()
    func closeQuerySuggestion()
    func didSelectItem(at index: Int)
    func togleBookInFavorites(book: Book)
    func fetchAllBooksById()
}

protocol BookListViewModelOutput {
    typealias DataAppendedHandler = () -> Void
    var booksArray: [Book] { get set }
    var savedBooksArray: [FavoriteBooks] {get}
    var savedBookDict: Set<String> {get set}
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
    var dataAppendedHandler: DataAppendedHandler? { get set }
    func appendData(_ books: [Book])
    
}

typealias BookListViewModelProtocol = BooksListViewModelInput & BookListViewModelOutput

class DefaultBookListViewModel: BookListViewModelProtocol {
    var savedBookDict: Set<String>
    var screenTitle: String = ""
    var emptyDataTitle: String = ""
    var errorTitle: String = ""
    var searchBarPlaceholder: String = ""
    var booksArray: [Book] = []
    var isEmpty: Bool = false
    var page: Int = 0
    var nextPage: Int { page + 1 }
    var query: String?
    private let actions: BooksListViewModelActions?
    private var searchBooksManager: SearchBooksUseCase!
    private var booksLoadTask: Cancellable? { willSet { booksLoadTask?.cancel() } }
    var dataAppendedHandler: DataAppendedHandler?
    var persistentStorage: BooksResponseStorage?
    var savedBooksArray: [FavoriteBooks] = []
    var savedBooksId: [String] = []
    
    init(searchBooksManager: SearchBooksUseCase!,
         actions: BooksListViewModelActions?,
         booksLoadTask: Cancellable? = nil) {
        self.searchBooksManager = searchBooksManager
        self.actions = actions
        self.booksLoadTask = booksLoadTask
        self.persistentStorage = CoreDataBooksResponseStorage()
        self.savedBookDict = []
    }
    
    private func update(booksQuery: BookQuery) {
        load(bookQuery: booksQuery, loading: .fullScreen)
    }
    
    private func load(bookQuery: BookQuery, loading: BookListViewModelLoading) {
        booksLoadTask = self.searchBooksManager.exexute(
            requestValue: .init(query: bookQuery, page: self.nextPage, limit: 12),
            completion: { result in
                switch result {
                case .success(let responseData):
                    self.appendData(responseData.books)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    internal func appendData(_ books: [Book]) {
        self.booksArray.append(contentsOf: books)
        dataAppendedHandler?()
    }
    
    private func resetPages() {
        self.page = 0
        self.booksArray.removeAll()
        dataAppendedHandler?()
    }
    
}

extension DefaultBookListViewModel {
    
    func viewDidLoad() {
        fetchAllBooksById()
    }
    
    func didLoadNextPage() {
        guard let query = self.query else {return}
        self.page += 1
        load(bookQuery: .init(query: query), loading: .nextPage)
    }
    
    func didSearch(query: String) {
        self.resetPages()
        guard !query.isEmpty else { return }
        self.query = query
        let bookQuery = BookQuery(query: query)
        update(booksQuery: bookQuery)
    }
    
    func didCancelSearch() {
        self.resetPages()
    }
    
    func showQuerySuggestion() { }
    
    func closeQuerySuggestion() { }
    
    func didSelectItem(at index: Int) {
        actions?.showBookDetails(booksArray[index])
    }
    
    func togleBookInFavorites(book: Book) {
        guard let id = book.coverId else {return}
        let stringId = String(id)
        persistentStorage?.fetchParticularFavBooksData(withId: stringId) { result in
            switch result {
            case true:
                self.removeFromPersistentStorage(stringId)
                self.fetchAllBooksById()
            case false:
                self.saveToPersistentStorage(withBook: book)
                self.fetchAllBooksById()
            }
        }
    }
    
    func removeFromPersistentStorage(_ id: String) {
        self.persistentStorage?.removeBookFromFavorites(withID: id) { result in
            switch result {
            case true:
                print("Removed from storage.")
            case false:
                print("Error in removing from storage.")
            }
        }
    }
    
    func saveToPersistentStorage(withBook book: Book) {
        self.persistentStorage?.save(response: book)
        print("Saved To core data")
    }
    
    func fetchAllBooksById() {
        self.persistentStorage?.fetchAllData { [weak self] result in
            guard let self = self else { return }
            for book in result {
                guard let booksId = book.bookId else {return}
                self.savedBookDict.insert(booksId)
                self.savedBooksArray.append(book)
            }
        }
    }
    
}
