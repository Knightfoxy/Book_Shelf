//
//  BooksQuery.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation

struct BookQuery: Equatable {
    let query: String
}

protocol Cancellable {
    func cancel()
}
