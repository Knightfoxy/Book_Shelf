//
//  CoreDataBooksResponseStorage.swift
//  BooksApp
//
//  Created by Ayush on 20/05/24.
//

import Foundation
import CoreData

final class CoreDataBooksResponseStorage: BooksResponseStorage {
    
    private var coreDataStorage: CoreDataStorage?
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    internal func fetchAllData(completion: @escaping ([FavoriteBooks]) -> Void) {
        coreDataStorage?.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteBooks> = FavoriteBooks.fetchRequest()
            
            do {
                let books  = try context.fetch(fetchRequest)
                completion(books)
            } catch {
                print("Error Fetching all data from Core data.")
                completion([])
            }
        }
    }
    
    internal func save(response responseDTO: Book) {
        coreDataStorage?.performBackgroundTask { context in
            
            guard let newBook = NSEntityDescription.insertNewObject(forEntityName: "FavoriteBooks", into: context) as? FavoriteBooks else { return }
            newBook.bookId = String(responseDTO.coverId ?? 0)
            newBook.authorName = responseDTO.authorName?[0]
            newBook.title = responseDTO.title
            
            do {
                try context.save()
                print("Successfully saved new book to core data.")
            } catch {
                print("Failed to save book: \(error)")
            }
            
        }
    }
    
    internal func fetchParticularFavBooksData(withId id: String, completion: @escaping (Bool) -> Void) {
        print("came to fetch data")
        coreDataStorage?.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteBooks")
            fetchRequest.predicate = NSPredicate(format: "bookId == %@", id)
            fetchRequest.fetchLimit = 1
            do {
                let count = try context.count(for: fetchRequest)
                completion(count > 0)
            } catch {
                print("Failed to fetch entity with id \(id): \(error)")
                completion(false)
            }
        }
    }
    
    internal func removeBookFromFavorites(withID id: String, completion: @escaping (Bool) -> Void) {
        coreDataStorage?.performBackgroundTask { context in
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteBooks")
            fetchRequest.predicate = NSPredicate(format: "bookId == %@", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject], let book = fetchResults.first {
                    context.delete(book)
                    try context.save()
                    print("Book deleted with id \(id).")
                    completion(true)
                } else {
                    print("No book found with id \(id).")
                    completion(false)
                }
            } catch {
                print("Failed to fetch or delete entity with id \(id): \(error)")
                completion(false)
            }
        }
    }
    
}
