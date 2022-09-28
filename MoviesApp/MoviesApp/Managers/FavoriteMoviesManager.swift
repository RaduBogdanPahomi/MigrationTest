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
    private let string = String()
    
    init() {
        self.favoriteMovies = loadSavedFavoriteMovies()
    }
    
    func setMovies(with list: [Movie]) {
        favoriteMovies = list
        saveFavoriteMovies()
    }
    
    func markMovie(movie: Movie, asFavorite favorite: Bool) {
        if favorite == true && !isFavoriteMovie(id: movie.id) {
            favoriteMovies.append(movie)
            saveFavoriteMovies()
        } else if favorite == false && isFavoriteMovie(id: movie.id) {
            favoriteMovies.removeAll { currentMovie in
                currentMovie.id == movie.id
            }
            saveFavoriteMovies()
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

private extension FavoriteMoviesManager {
    func saveFavoriteMovies() {
        guard let path = String.getFavoriteMoviesPath() else { return }

        do {
            let jsonData = try JSONEncoder().encode(favoriteMovies)
            try jsonData.write(to: path, options: [])
        } catch {
            print("Cannot save on disk \(error)")
        }
    }
    
    func loadSavedFavoriteMovies()-> [Movie] {
        guard let path = String.getFavoriteMoviesPath() else { return [] }
        
        do {
            let data = try Data(contentsOf: path, options: [])
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Cannot read from disk \(error)")
            return []
        }
    }
}
