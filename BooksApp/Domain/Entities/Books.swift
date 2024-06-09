//
//  Books.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import Foundation

struct Book: Equatable {
    let authorName: [String]?
    let title: String?
    let ratingsAverage: Double?
    let ratingsCount: Int?
    let coverId: Int?
    var isFav: Bool?
}

struct BooksPage: Equatable {
    let books: [Book]
}
