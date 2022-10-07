//
//  Keywords.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 05.10.2022.
//

import Foundation

struct Keyword: Hashable, Codable {
    let id: Int
    let name: String
}

struct Keywords: Codable {
    let page: Int
    let results: [Keyword]?
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
