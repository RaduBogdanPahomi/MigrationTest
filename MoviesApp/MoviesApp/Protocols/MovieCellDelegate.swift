//
//  MovieCellDelegate.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 29.09.2022.
//

protocol MovieCellDelegate: AnyObject {
    func markAsFavorite(movie: Movie, favorite: Bool)
}
