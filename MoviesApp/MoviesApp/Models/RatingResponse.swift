//
//  RatingResponse.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.10.2022.
//

import Foundation

struct RatingResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
