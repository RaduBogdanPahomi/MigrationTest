//
//  AuthEndpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.10.2022.
//

enum AuthEndpoint {
    case requestToken
    case logInRequest(username: String, password: String, token: String)
    case createSession(token: String)
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .requestToken:
            return "/3/authentication/token/new"
        case .logInRequest:
            return "/3/authentication/token/validate_with_login"
        case .createSession:
            return "/3/authentication/session/new"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .requestToken:
            return .get
        case .logInRequest, .createSession:
            return .post
        }
    }
    
    var header: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDBjMmI0OWM4ZDNkMTg3MDRiMDkyMzc0ZjM2ZGNjNSIsInN1YiI6IjYyZmYyYzE0YmM4NjU3MDA4MzdjOGE4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wO7miNgox_YNDY-qNU0BKAEM_bgd9ewsIR38f-NJZZg"
        switch self {
        case .requestToken, .logInRequest, .createSession:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var queryStrings: [String : String?]? {
        let apiKey = "626d05abf324b3be1c089c695497d49c"
        var queryParameters = ["api_key": apiKey]
        switch self {
        case .logInRequest(username: let username, password: let password, token: let token):
            queryParameters["username"] = "\(username)"
            queryParameters["password"] = "\(password)"
            queryParameters["request_token"] = "\(token)"
        case .createSession(token: let token):
            queryParameters["request_token"] = "\(token)"
        default:
            return queryParameters
        }
        return queryParameters
    }
}
