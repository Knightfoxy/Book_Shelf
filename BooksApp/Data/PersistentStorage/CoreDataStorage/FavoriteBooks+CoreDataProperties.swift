//
//  FavoriteBooks+CoreDataProperties.swift
//  
//
//  Created by Ayush on 20/05/24.
//
//

import Foundation
import CoreData


extension FavoriteBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBooks> {
        return NSFetchRequest<FavoriteBooks>(entityName: "FavoriteBooks")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var bookId: String?
    @NSManaged public var title: String?

}
