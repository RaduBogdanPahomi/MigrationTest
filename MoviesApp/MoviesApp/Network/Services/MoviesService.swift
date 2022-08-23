//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation

protocol MoviesServiceable {
    func getTopRated() async -> Result<TopRated, RequestError>
    func getMovie(id: Int) async -> Result<Movie, RequestError>
}

struct MovieService: HTTPClient, MoviesServiceable {
    func getTopRated() async -> Result<TopRated, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: TopRated.self)
    }
    
    func getMovie(id: Int) async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movie(id: id), responseModel: Movie.self)
    }
}
