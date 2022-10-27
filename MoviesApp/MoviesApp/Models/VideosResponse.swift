//
//  VideosResponse.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 25.10.2022.
//

import Foundation

struct VideoResult: Codable {
    let iso639: String
    let iso3166: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case iso639 = "iso_639_1"
        case iso3166 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}

struct VideosResponse: Codable {
    let id: Int
    let results: [VideoResult]
    
    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}
