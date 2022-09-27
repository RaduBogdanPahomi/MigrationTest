//
//  SortType.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 26.09.2022.
//

enum SortType: String, CaseIterable {
    case popularity = "Popularity"
    case releaseDate = "Release date"
    case rating = "Rating"
    case ascTitle = "Title (A-Z)"
    case descTitle = "Title (Z-A)"
    
    func sortQueryParameter() -> String {
        switch self {
        case .popularity:
             return "popularity.desc"
        case .releaseDate:
            return "release_date.desc"
        case .rating:
            return "vote_average.desc"
        case .ascTitle:
            return "original_title.asc"
        case .descTitle:
            return "original_title.desc"
        }
    }
}
