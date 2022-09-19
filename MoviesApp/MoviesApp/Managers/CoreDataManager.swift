//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 16.09.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Favorites")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            container.viewContext.mergePolicy = NSOverwriteMergePolicy
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    func saveContext() {
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
    
    func isFavoriteMovie(withId movieId: Int) -> Bool {
        let managedContext = persistentContainer.viewContext
                
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        let count = (try? managedContext.count(for: fetchRequest)) ?? 0

        return count > 0
    }
        
    func markMovie(withId movieId: Int, asFavorite favorite: Bool) {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        
        if favorite == false {
            deleteFavoriteMovie(withId: movieId)
        } else {
            addFavoriteMovie(withId: movieId)
        }
    }
    
    func getMovie(withId movieId: Int) -> Movie? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        
        do {
            guard let movie = try managedContext.fetch(fetchRequest).first else { return nil }
            return movie
        } catch {
            return nil
        }
    }
    
    func getAllFavouriteMovies() -> [Movie]? {
        let managedContext = persistentContainer.viewContext
        let favoriteRequest = Favorite.fetchRequest()
        let fetchRequest = Movie.fetchRequest()

        do {
            let favorites = try managedContext.fetch(favoriteRequest).map({ fav in
                fav.id
            })
            let ids = try managedContext.fetch(fetchRequest).map({ mov in
                mov.id
            })
            
            fetchRequest.predicate = NSPredicate(format: "id IN %@", favorites)
            return try managedContext.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func getAllMovies() -> [Movie]? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = Movie.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

    func deleteFavoriteMovie(withId movieId: Int) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        
        do {
            guard let movie = try managedContext.fetch(fetchRequest).first else { return }
            managedContext.delete(movie)
            
            saveContext()
        } catch {
            print(error)
        }
    }
    
    func addFavoriteMovie(withId movieId: Int) {
        let managedContext = persistentContainer.viewContext
        
        let movie = Favorite(context: managedContext)
        movie.id = Int64(movieId)

        saveContext()
    }
    
    func deleteAllMovies() {
        let managedContext = persistentContainer.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Movie.fetchRequest())

        do {
            try  managedContext.execute(deleteRequest)
        } catch {
            // TODO: handle the error
        }
    }
}
