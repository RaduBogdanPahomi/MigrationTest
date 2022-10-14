//
//  Account.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.10.2022.
//

import Foundation

struct Gravatar: Hashable, Codable {
    let hash: String
}

struct Avatar: Hashable, Codable {
    let gravatar: Gravatar
}

struct Account: Codable {
    let avatar: Avatar
    let id: Int
    let iso639: String
    let iso3166: String
    let name: String
    let includeAdult: Bool
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case iso639 = "iso_639_1"
        case iso3166 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}
