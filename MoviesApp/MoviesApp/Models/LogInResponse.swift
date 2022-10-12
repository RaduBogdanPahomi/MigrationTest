//
//  Authentication.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 07.10.2022.
//

import Foundation

struct LogInResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
