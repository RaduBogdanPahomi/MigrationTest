//
//  TopRated.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 22.08.2022.
//

import Foundation

struct MovieList: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}
