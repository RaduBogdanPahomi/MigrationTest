//
//  SimilarMovies.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 26.08.2022.
//

import Foundation

struct SimilarMovies: Codable {
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
