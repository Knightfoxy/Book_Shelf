//
//  APIEndpoints.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation

struct APIEndpoints {
    
    static func getBooks(with booksRequestDTO: BooksRequestDTO) -> Endpoint<BooksResponseDTO> {

        return Endpoint(
            path: "search.json?q=",
            method: .get,
            queryParametersEncodable: booksRequestDTO
        )
    }

    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {

        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes
            .enumerated()
            .min { abs($0.1 - width) < abs($1.1 - width) }?
            .element ?? sizes.first!
        
        return Endpoint(
            path: "t/p/w\(closestWidth)\(path)",
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
