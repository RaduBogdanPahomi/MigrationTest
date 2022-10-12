//
//  Session.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.10.2022.
//

import Foundation

struct Session: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
