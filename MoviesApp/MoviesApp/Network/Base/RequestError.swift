//
//  RequestError.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation

enum RequestError: Error {
    case decode(error: DecodingError)
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case invalidURL
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode(let error):
            switch error {
            case .typeMismatch:
                return "Decode error: Type mismatch"
            case .valueNotFound(let any, _):
                return "Decode error: Value \(any) not found"
            case .keyNotFound(let codingKey, _):
                return "Decode error: \(codingKey)"
            case .dataCorrupted:
                return "Decode error: Data corrupted"
            @unknown default:
                fatalError()
            }
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
