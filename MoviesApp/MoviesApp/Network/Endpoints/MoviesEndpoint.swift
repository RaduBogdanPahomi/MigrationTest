//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

enum MoviesEndpoint {
    case movie(id: Int)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .movie(let id):
            return "/3/movie/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .movie:
            return .get
        }
    }
    
    var header: [String : String]? {
        let accessToken = ""
        switch self {
        case .movie:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .movie:
            return .none
        }
    }
}
