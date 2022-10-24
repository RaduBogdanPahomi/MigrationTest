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
    case accountDetails(sessionID: String)
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
        case .accountDetails:
            return "/3/account"
        }
        
    }
    
    var method: RequestMethod {
        switch self {
        case .requestToken, .accountDetails:
            return .get
        case .logInRequest, .createSession:
            return .post
        }
    }
    
    var queryStrings: [String : String?]? {
        let apiKey = UserManager.shared.apiKey
        var queryParameters = ["api_key": apiKey]
        switch self {
        case .logInRequest(username: let username, password: let password, token: let token):
            queryParameters["username"] = "\(username)"
            queryParameters["password"] = "\(password)"
            queryParameters["request_token"] = "\(token)"
        case .createSession(token: let token):
            queryParameters["request_token"] = "\(token)"
        case .accountDetails(sessionID: let sessionID):
            queryParameters["session_id"] = "\(sessionID)"
        default:
            return queryParameters
        }
        return queryParameters
    }
}
