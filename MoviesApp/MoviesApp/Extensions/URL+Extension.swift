//
//  URL+Extension.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 24.08.2022.
//

import Foundation

extension URL {
    mutating func setQueryString(_ queries: [String: String?]) {
        queries.forEach { key, value in
            guard let value = value else { return }
            guard var urlComponents = URLComponents(string: absoluteString) else { return }

            // Create array of existing query items
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

            // Create query item
            let queryItem = URLQueryItem(name: key, value: value)

            // Append the new query item in the existing query items array
            queryItems.append(queryItem)

            // Append updated query items array in the url component object
            urlComponents.queryItems = queryItems

            self = urlComponents.url!
        }
    }
}
