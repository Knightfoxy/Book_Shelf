//
//  BookResponseDTO+Mapping.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation


struct BooksResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case books = "docs"
    }

    let books: [BookDTO]
}

extension BooksResponseDTO {
    struct BookDTO: Decodable {
        let title: String?
        let authorName: [String]?
        let ratingsAverage: Double?
        let ratingsCount: Int?
        let coverId: Int?

        private enum CodingKeys: String, CodingKey {
            case title
            case authorName = "author_name"
            case ratingsAverage = "ratings_average"
            case ratingsCount = "ratings_count"
            case coverId = "cover_i"
        }
    }
}

// MARK: - Mappings to Domain

extension BooksResponseDTO {
    
    func toDomain() -> BooksPage {
        return .init(books: books.map { $0.toDomain()})
    }
}

extension BooksResponseDTO.BookDTO {
    func toDomain() -> Book {
        return Book(authorName: authorName, title: title, ratingsAverage: ratingsAverage, ratingsCount: ratingsCount, coverId: coverId)
    }
}
