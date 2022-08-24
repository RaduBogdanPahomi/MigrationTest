//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

enum MoviesEndpoint {
    case topRated
    case movie(id: Int)
}

extension MoviesEndpoint: Endpoint {    
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movie(let id):
            return "/3/movie/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .topRated, .movie:
            return .get
        }
    }
    
    var header: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDBjMmI0OWM4ZDNkMTg3MDRiMDkyMzc0ZjM2ZGNjNSIsInN1YiI6IjYyZmYyYzE0YmM4NjU3MDA4MzdjOGE4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wO7miNgox_YNDY-qNU0BKAEM_bgd9ewsIR38f-NJZZg"
        switch self {
        case .topRated, .movie:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .topRated, .movie:
            return nil
        }
    }
    
    var queryStrings: [String: String?]? {
        let apiKey = "626d05abf324b3be1c089c695497d49c"
        return ["api_key": apiKey]
    }
}
