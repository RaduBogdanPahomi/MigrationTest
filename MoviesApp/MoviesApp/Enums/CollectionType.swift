//
//  CollectionType.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 31.10.2022.
//

import Foundation

enum CollectionType: String, CaseIterable {
    case latestMovies = "Latest"
    case nowPlaying = "Now Playing"
    case popularMovies = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"

    func sortQueryParameter() -> String {
        switch self {
        case .latestMovies:
             return "latest"
        case .nowPlaying:
            return "now_playing"
        case .popularMovies:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        }
    }
}
