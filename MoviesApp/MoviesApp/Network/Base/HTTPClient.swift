//
//  HTTPClient.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation
import UIKit

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard var url = urlComponents.url else {
            return.failure(.invalidURL)
        }
        
        if let queryStrings = endpoint.queryStrings {
            url.setQueryString(queryStrings)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                let jsonDecoder = JSONDecoder()
                jsonDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataManager.sharedManager.persistentContainer.viewContext
                guard let decodeResponse = try? jsonDecoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodeResponse)
            case 401:
                return.failure(.unauthorized)
            default:
                return.failure(.unexpectedStatusCode)
            }
        } catch {
            return.failure(.unknown)
        }
    }
}
