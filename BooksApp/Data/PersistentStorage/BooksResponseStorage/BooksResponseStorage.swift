//
//  BooksResponseStorage.swift
//  BooksApp
//
//  Created by Ayush on 20/05/24.
//

import Foundation

protocol BooksResponseStorage {
    
    func save(response responseDTO: Book)
    
    func fetchParticularFavBooksData(withId id: String, completion: @escaping (Bool) -> Void)
    
    func removeBookFromFavorites(withID id: String, completion: @escaping (Bool) -> Void)
    
    func fetchAllData(completion: @escaping ([FavoriteBooks]) -> Void)
    
}
