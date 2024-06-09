//
//  BookListRepository.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import Foundation

class BookListRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
    
}

extension BookListRepository: BooksListProtocol {

    func fetchBooksList(query: BookQuery, limit: Int, page: Int, completion: @escaping (Result<BooksPage, Error>) -> Void) -> Cancellable? {
        let requestDTO = BooksRequestDTO(page: page, limit: limit, q: query.query)
            let task = RepositoryTask()
            guard !task.isCancelled else { return nil }
            let endpoint = APIEndpoints.getBooks(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint, completion: { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                    print(responseDTO)
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            return task
        }
}
