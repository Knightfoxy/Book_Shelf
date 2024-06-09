//
//  BookDetailViewModel.swift
//  BooksApp
//
//  Created by Ayush on 17/04/24.
//

import Foundation


protocol BookDetailInput {
}

protocol BookDetailOutput {
    var bookDetail: Book { get }
}

typealias BookDetailProtocol = BookDetailInput & BookDetailOutput

class BookDetailViewModel: BookDetailProtocol {
    
    var bookDetail: Book
    
    init(bookDetail: Book) {
        self.bookDetail = bookDetail
    }
    
}
