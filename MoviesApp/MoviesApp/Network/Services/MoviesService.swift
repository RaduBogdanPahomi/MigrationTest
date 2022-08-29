//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation

protocol MoviesServiceable {
    func getMovieList() async -> Result<MovieList, RequestError>
    func getMovie(id: Int) async -> Result<Movie, RequestError>
    func getSimilarMovies(id: Int) async -> Result<SimilarMovies, RequestError>
}

struct MovieService: HTTPClient, MoviesServiceable {
    func getMovieList() async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieList, responseModel: MovieList.self)
    }
    
    func getMovie(id: Int) async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movie(id: id), responseModel: Movie.self)
    }
    
    func getSimilarMovies(id: Int) async -> Result<SimilarMovies ,RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.similarMovie(id: id), responseModel: SimilarMovies.self)
    }
}
