//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

enum MoviesEndpoint {
    case movieList(page: Int, sortType: String)
    case movie(id: Int)
    case similarMovie(page: Int, id: Int)
    case searchMovie(page: Int, keyword: String)
}

extension MoviesEndpoint: Endpoint {    
    var path: String {
        switch self {
        case .movieList:
            return "/3/discover/movie"
        case .movie(let id):
            return "/3/movie/\(id)"
        case .similarMovie(_, let id):
            return "/3/movie/\(id)/similar"
        case .searchMovie:
            return"/3/search/movie"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .movieList, .movie, .similarMovie, .searchMovie:
            return .get
        }
    }
    
    var header: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDBjMmI0OWM4ZDNkMTg3MDRiMDkyMzc0ZjM2ZGNjNSIsInN1YiI6IjYyZmYyYzE0YmM4NjU3MDA4MzdjOGE4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wO7miNgox_YNDY-qNU0BKAEM_bgd9ewsIR38f-NJZZg"
        switch self {
        case .movieList, .movie, .similarMovie, .searchMovie:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .movieList, .movie, .similarMovie, .searchMovie:
            return nil
        }
    }
    
    var queryStrings: [String: String?]? {
        let apiKey = "626d05abf324b3be1c089c695497d49c"
        var queryParameters = ["api_key": apiKey]
        
        if case .movieList(let page, let sortType) = self {
            queryParameters["sort_by"] = sortType
            queryParameters["page"] = "\(page)"
        }
        
        if case .similarMovie(let page, _) = self {
            queryParameters["page"] = "\(page)"
        }
        
        if case .searchMovie(let page, let keyword) = self {
            queryParameters["query"] = "\(keyword)"
            queryParameters["page"] = "\(page)"
        }
        
        return queryParameters
    }
}
