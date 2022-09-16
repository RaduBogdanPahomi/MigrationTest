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
    
    func isFavoriteMovie(withId movieId: Int) -> Bool {
        return getMovie(withId: movieId) != nil
    }
        
    func markMovie(movie: Movie, withId movieId: Int, asFavorite favorite: Bool) {
        //If movie exists, then we will remove the record
        if favorite == false {
            deleteMovie(favMovie: movie)
        } else {
            addMovie(favMovie: movie)
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = FavoriteMovie.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

    func deleteMovie(favMovie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(favMovie.id)")
        
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
    
    func addMovie(favMovie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let movie = FavoriteMovie(context: managedContext)
        movie.id = Int64(favMovie.id)
        movie.voteAverage = favMovie.voteAverage
        movie.originalTitle = favMovie.originalTitle
        movie.posterPath = favMovie.posterPath
        movie.releaseDate = favMovie.releaseDate
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        allFavouriteMovies = getAllFavouriteMovies()
    }
}

