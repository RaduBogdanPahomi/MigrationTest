//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

enum MoviesEndpoint {
    case movieList(page: Int, sortType: String)
    case movie(id: Int)
    case latestMovie
    case similarMovie(page: Int, id: Int)
    case exploreMovies(page: Int, type: String)
    case searchMovie(page: Int, keyword: String)
    case searchKeyword(keyword: String)
    case rateMovie(id: Int, sessionID: String, rating: Double)
    case movieReviews(id: Int, page: Int)
    case movieVideos(id: Int)
}

extension MoviesEndpoint: Endpoint {    
    var path: String {
        switch self {
        case .movieList:
            return "/3/discover/movie"
        case .movie(let id):
            return "/3/movie/\(id)"
        case .latestMovie:
            return "/3/movie/latest"
        case .similarMovie(_, let id):
            return "/3/movie/\(id)/similar"
        case .exploreMovies(_, let type):
            return "/3/movie/\(type)"
        case .searchMovie:
            return "/3/search/movie"
        case .searchKeyword:
            return "/3/search/keyword"
        case .rateMovie(let id, _, _):
            return "/3/movie/\(id)/rating"
        case .movieReviews(let id, _):
            return "/3/movie/\(id)/reviews"
        case .movieVideos(let id):
            return "/3/movie/\(id)/videos"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .movieList, .movie, .latestMovie, .similarMovie, .exploreMovies, .searchMovie, .searchKeyword, .movieReviews, .movieVideos:
            return .get
        case .rateMovie:
            return .post
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
        case .exploreMovies(page: let page, _):
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
        case .movieReviews(_, page: let page):
            queryParameters["page"] = "\(page)"
        default:
            return queryParameters
        }
        
        return queryParameters
    }
}
