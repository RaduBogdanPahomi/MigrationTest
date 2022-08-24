//
//  Endpoint.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

protocol Endpoint {
    var scheme: String {get}
    var host: String {get}
    var path: String {get}
    var method: RequestMethod {get}
    var queryStrings: [String: String?]? {get}
    var header: [String: String]? {get}
    var body: [String: String]? {get}
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.themoviedb.org"
    }
    
    var queryStrings: [String : String?]? {
        return nil
    }
}
