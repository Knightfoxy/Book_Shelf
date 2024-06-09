//
//  BookListManager.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import Foundation

protocol SearchBooksUseCase {
    func exexute(requestValue: SearchBooksUseCaseRequestValue, completion: @escaping (Result<BooksPage, Error>) -> Void) -> Cancellable?
}

class BookListManager: SearchBooksUseCase {
    
    private let booksRepository: BooksListProtocol

    init(booksRepository: BooksListProtocol) {
        self.booksRepository = booksRepository
    }
    
    func exexute(requestValue: SearchBooksUseCaseRequestValue, completion: @escaping (Result<BooksPage, Error>) -> Void) -> Cancellable? {
        return booksRepository.fetchBooksList(query: requestValue.query, limit: requestValue.limit, page: requestValue.page) { result in
            switch result {
            case .success(_):
                completion(result)
            case .failure(let error):
                printIfDebug(error.localizedDescription)
            }
        }
    }
}

struct SearchBooksUseCaseRequestValue {
    let query: BookQuery
    let page: Int
    let limit: Int
}

