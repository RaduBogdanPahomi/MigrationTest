//
//  AuthService.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.10.2022.
//

protocol AuthServiceable {
    func getAuthenticationToken() async -> Result<LogInResponse, RequestError>
    func postCredentials(username: String, password: String, token: String) async -> Result<LogInResponse, RequestError>
    func createSession(token: String) async -> Result<Session, RequestError>
}

struct AuthService: HTTPClient, AuthServiceable {
    func getAuthenticationToken() async -> Result<LogInResponse, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.requestToken, responseModel: LogInResponse.self)
    }
    
    func postCredentials(username: String, password: String, token: String) async -> Result<LogInResponse, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.logInRequest(username: username, password: password, token: token), responseModel: LogInResponse.self)
    }
    
    func createSession(token: String) async -> Result<Session, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.createSession(token: token), responseModel: Session.self)
    }
}
