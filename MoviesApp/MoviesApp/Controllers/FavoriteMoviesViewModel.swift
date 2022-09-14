//
//  FavoriteMoviesViewModel.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 14.09.2022.
//

import Foundation
import UIKit
import CoreData

final class FavoriteMovieViewModel: NSObject {
    var allFavouriteMovies: [FavoriteMovie]?
    
    override init() {
        super.init()
        
        allFavouriteMovies = getAllFavouriteMovies()
    }
    
    func markMovie(withId movieId: Int, asFavorite favorite: Bool) {
        //If movie exists, then we will remove the record
        if favorite == false {
            deleteMovie(withId: movieId)
        } else {
            addMovie(withId: movieId)
        }
    }
    
    func getMovie(withId movieId: Int) -> FavoriteMovie? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        
        do {
            guard let movie = try managedContext.fetch(fetchRequest).first else { return nil }
            return movie
        } catch {
            return nil
        }
    }
    
    func getAllFavouriteMovies() -> [FavoriteMovie]? {
        
        print(" ----- getAllFavouriteMovies")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = FavoriteMovie.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

    func deleteMovie(withId movieId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        
        do {
            guard let movie = try managedContext.fetch(fetchRequest).first else { return }
            managedContext.delete(movie)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        allFavouriteMovies = getAllFavouriteMovies()
    }
    
    func addMovie(withId movieId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let movie = FavoriteMovie(context: managedContext)
        movie.id = Int64(movieId)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        allFavouriteMovies = getAllFavouriteMovies()
    }
}

