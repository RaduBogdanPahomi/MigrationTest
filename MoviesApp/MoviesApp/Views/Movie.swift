//
//  Movie.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.08.2022.
//

import Foundation

struct Movie: Codable {
    let title: String
    let rating: Double
    let releaseYear: Int
    let genreIDS: [Int]?

    enum CodingKeys: String, CodingKey {
        case title
        case rating
        case releaseYear
        case genreIDS
    }
}
