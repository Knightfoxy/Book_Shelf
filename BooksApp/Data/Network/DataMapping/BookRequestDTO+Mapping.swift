//
//  BookRequestDTO+Mapping.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation

struct BooksRequestDTO: Encodable {
    let page: Int
    let limit: Int
    let q: String
}
