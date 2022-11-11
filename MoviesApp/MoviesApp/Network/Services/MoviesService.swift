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
    func getLatestMovie() async -> Result<Movie, RequestError>
    func getSimilarMovies(page: Int, id: Int) async -> Result<SimilarMovies, RequestError>
    func getExploreMovies(page: Int, type: String) async -> Result<MovieList, RequestError>
    func getSearchMovies(page: Int, keyword: String) async -> Result<MovieList, RequestError>
    func getSearchKeyword(keyword: String) async -> Result<Keywords, RequestError>
    func getMovieReviews(id: Int, page: Int) async -> Result<Reviews, RequestError>
    func getVideos(id: Int) async -> Result<VideosResponse, RequestError>
    func getMoviesWithGenre(genreID: Int) async -> Result<MovieList, RequestError>
    func postMovieRating(id: Int, sessionID: String, rating: Double) async -> Result<RatingResponse, RequestError>
}

struct MovieService: HTTPClient, MoviesServiceable {
    func getMovieList(page: Int, sortType: String) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieList(page: page, sortType: sortType), responseModel: MovieList.self)
    }
    
    func getMovie(id: Int) async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movie(id: id), responseModel: Movie.self)
    }
    
    func getLatestMovie() async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.latestMovie, responseModel: Movie.self)
    }
    
    func getSimilarMovies(page: Int, id: Int) async -> Result<SimilarMovies ,RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.similarMovie(page: page, id: id), responseModel: SimilarMovies.self)
    }
    
    func getExploreMovies(page: Int, type: String) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.exploreMovies(page: page, type: type), responseModel: MovieList.self)
    }
    
    func getSearchMovies(page: Int, keyword: String) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.searchMovie(page: page, keyword: keyword), responseModel: MovieList.self)
    }
    
    func getSearchKeyword(keyword: String) async -> Result<Keywords, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.searchKeyword(keyword: keyword), responseModel: Keywords.self)
    }
    
    func getMovieReviews(id: Int, page: Int) async -> Result<Reviews, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieReviews(id: id, page: page), responseModel: Reviews.self)
    }
    
    func getVideos(id: Int) async -> Result<VideosResponse, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieVideos(id: id), responseModel: VideosResponse.self)
    }

    func getMoviesWithGenre(genreID: Int) async -> Result<MovieList, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieWithGenre(genreID: genreID), responseModel: MovieList.self)
    }
    
    func postMovieRating(id: Int, sessionID: String, rating: Double) async -> Result<RatingResponse, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.rateMovie(id: id, sessionID: sessionID, rating: rating), responseModel: RatingResponse.self)
    }
}
