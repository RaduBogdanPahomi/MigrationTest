//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

enum MoviesEndpoint {
    case movieList
    case movie(id: Int)
    case similarMovie(id: Int)
}

extension MoviesEndpoint: Endpoint {    
    var path: String {
        switch self {
        case .movieList:
            return "/3/discover/movie"
        case .movie(let id):
            return "/3/movie/\(id)"
        case .similarMovie(let id):
            return "/3/movie/\(id)/similar"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .movieList, .movie, .similarMovie:
            return .get
        }
    }
    
    var header: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDBjMmI0OWM4ZDNkMTg3MDRiMDkyMzc0ZjM2ZGNjNSIsInN1YiI6IjYyZmYyYzE0YmM4NjU3MDA4MzdjOGE4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wO7miNgox_YNDY-qNU0BKAEM_bgd9ewsIR38f-NJZZg"
        switch self {
        case .movieList, .movie, .similarMovie:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .movieList, .movie, .similarMovie:
            return nil
        }
    }
    
    var queryStrings: [String: String?]? {
        let apiKey = "626d05abf324b3be1c089c695497d49c"
        return ["api_key": apiKey]
    }
}
