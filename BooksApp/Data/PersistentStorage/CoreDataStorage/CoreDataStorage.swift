//
//  CoreDataStorage.swift
//  BooksApp
//
//  Created by Ayush on 20/05/24.
//

import Foundation
import CoreData

final class CoreDataStorage {
    
    static var shared = CoreDataStorage()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BooksApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping  (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
