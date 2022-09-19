//
//  FavoritesManager.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 19.09.2022.
//

import Foundation

import UIKit

public final class FavoriteMoviesManager {
    
    static let shared = FavoriteMoviesManager()
    private(set) var favoriteMovies: [Movie] = []
    
    func setMovies(with list: [Movie]) {
        favoriteMovies = list
    }
    
    func markMovie(movie: Movie, asFavorite favorite: Bool) {
        if favorite == true && !isFavoriteMovie(id: movie.id) {
            favoriteMovies.append(movie)
        } else if favorite == false && isFavoriteMovie(id: movie.id) {
            favoriteMovies.removeAll { currentMovie in
                currentMovie.id == movie.id
            }
        }
    }
    
    func changeFavoriteState(forMovie movie: Movie) {
        let movieState = isFavoriteMovie(id: movie.id)
        markMovie(movie: movie, asFavorite: !movieState)
    }
    
    func isFavoriteMovie(id: Int) -> Bool {
        return favoriteMovies.contains { movie in
            movie.id == id
        }
    }
}
