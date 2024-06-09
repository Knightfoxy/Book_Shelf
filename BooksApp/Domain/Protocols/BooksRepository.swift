//
//  BooksRepository.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import Foundation


protocol BooksListProtocol {
    func fetchBooksList(query: BookQuery, limit: Int, page: Int, completion: @escaping (Result<BooksPage, Error>) -> Void) -> Cancellable? 
}

