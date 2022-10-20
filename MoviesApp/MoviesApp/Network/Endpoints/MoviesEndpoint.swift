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
    case searchKeyword(keyword: String)
    case rateMovie(id: Int, sessionID: String, rating: Float)
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
            return "/3/search/movie"
        case .searchKeyword:
            return "/3/search/keyword"
        case .rateMovie(let id, _, _):
            return "/3/movie/\(id)/rating"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .movieList, .movie, .similarMovie, .searchMovie, .searchKeyword:
            return .get
        case .rateMovie:
            return .post
        }
    }
    
    var header: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDBjMmI0OWM4ZDNkMTg3MDRiMDkyMzc0ZjM2ZGNjNSIsInN1YiI6IjYyZmYyYzE0YmM4NjU3MDA4MzdjOGE4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wO7miNgox_YNDY-qNU0BKAEM_bgd9ewsIR38f-NJZZg"
        switch self {
        case .movieList, .movie, .similarMovie, .searchMovie, .searchKeyword, .rateMovie:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : Codable]? {
        if case .rateMovie(_, _, let rating) = self {
            return ["value": rating]
        }
        return nil
    }
    
    var queryStrings: [String: String?]? {
        let apiKey = UserManager.shared.apiKey
        var queryParameters = ["api_key": apiKey]

        switch self {
        case .movieList(page: let page, sortType: let sortType):
            queryParameters["sort_by"] = sortType
            queryParameters["page"] = "\(page)"
        case .similarMovie(page: let page, _):
            queryParameters["page"] = "\(page)"
        case .searchMovie(page: let page, keyword: let keyword):
            queryParameters["query"] = "\(keyword)"
            queryParameters["page"] = "\(page)"
        case .searchKeyword(keyword: let keyword):
            if keyword.isEmpty == false {
            queryParameters["query"] = "\(keyword)"
            } else {
            queryParameters["query"] = "\"\""
            }
        case .rateMovie(_, sessionID: let sessionID, _):
            queryParameters["session_id"] = "\(sessionID)"
        default:
            return queryParameters
        }
        
        return queryParameters
    }
}
