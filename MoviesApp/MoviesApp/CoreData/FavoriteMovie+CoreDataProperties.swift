//
//  FavoriteMovie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.09.2022.
//
//

import Foundation
import CoreData


public extension FavoriteMovie {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var id: Int64
    @NSManaged public var backdropPath: String?
    @NSManaged public var originalLanguage: String?
    
    internal class func createOrUpdate(item: FavoriteMovieModelItem, with stack: CoreDataStack) {
            let favoriteItemId = item.id
            var currentFavoriteMovie: FavoriteMovie? // Entity name
            let favoriteMovieFetch: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
            if let favoriteItemId = newsItemID {
                let favoriteItemIdPredicate = NSPredicate(format: "%K == %i", #keyPath(FavoriteMovie.postID), favoriteItemId)
                favoriteMovieFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favoriteItemIdPredicate])
            }
            do {
                let results = try stack.managedContext.fetch(favoriteMovieFetch)
                if results.isEmpty {
                    // News post not found, create a new.
                    currentFavoriteMovie = FavoriteMovie(context: stack.managedContext)
                    if let postID = favoriteItemId {
                        currentFavoriteMovie?.postID = Int32(postID)
                    }
                } else {
                    // News post found, use it.
                    currentFavoriteMovie = results.first
                }
                currentFavoriteMovie?.update(item: item)
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
    }
    
    internal func update(item: FavoriteMovieModelItem) {
        self.id = item.id
        self.adult = item.adult
        self.backdropPath = item.backdropPath
        self.originalLanguage = item.originalLanguage
    }
}

extension FavoriteMovie : Identifiable {

}
