//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 19.08.2022.
//

import Foundation

protocol MoviesServiceable {
    func getMovieList(page: Int, sortType: String) async -> Result<MovieList, RequestError>
    func getMovie(id: Int) async -> Result<Movie, RequestError>
    func getSimilarMovies(page: Int, id: Int) async -> Result<SimilarMovies, RequestError>
    func getSearchMovies(page: Int, keyword: String) async -> Result<MovieList, RequestError>
    func getSearchKeyword(keyword: String) async -> Result<Keywords, RequestError>
    func postMovieRating(id: Int, sessionID: String, rating: Float) async -> Result<RatingResponse, RequestError>
}

struct MovieService: HTTPClient, MoviesServiceable {
    func getMovieList(page: Int, sortType: String) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieList(page: page, sortType: sortType), responseModel: MovieList.self)
    }
    
    func getMovie(id: Int) async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movie(id: id), responseModel: Movie.self)
    }
    
    func getSimilarMovies(page: Int, id: Int) async -> Result<SimilarMovies ,RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.similarMovie(page: page, id: id), responseModel: SimilarMovies.self)
    }
    
    func getSearchMovies(page: Int, keyword: String) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.searchMovie(page: page, keyword: keyword), responseModel: MovieList.self)
    }
    
    func getSearchKeyword(keyword: String) async -> Result<Keywords, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.searchKeyword(keyword: keyword), responseModel: Keywords.self)
    }
    
    func postMovieRating(id: Int, sessionID: String, rating: Float) async -> Result<RatingResponse, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.rateMovie(id: id, sessionID: sessionID, rating: rating), responseModel: RatingResponse.self)
    }
}
