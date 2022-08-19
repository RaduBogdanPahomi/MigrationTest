//
//  RequestError.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation

enum RequestError: Error {
    case decode
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case invalidURL
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decoding error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
