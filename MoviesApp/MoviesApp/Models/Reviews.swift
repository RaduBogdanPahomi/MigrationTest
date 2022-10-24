//
//  Reviews.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 21.10.2022.
//

import Foundation

struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Float?
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}

struct Review: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

struct Reviews: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
