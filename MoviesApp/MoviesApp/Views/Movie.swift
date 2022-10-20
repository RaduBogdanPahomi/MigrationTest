//
//  Movie.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.08.2022.
//

import Foundation

struct Genre: Hashable, Codable {
    let id: Int?
    let name: String?
}

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let runtime: Double?
    let imageSize = 500
    let posterBaseURL = "https://image.tmdb.org/t/p/w"
    
    enum CodingKeys: String, CodingKey {
        case adult
        case overview
        case popularity
        case id
        case title
        case video
        case genres
        case runtime
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func composedPosterPath() -> String {
        return posterBaseURL + "\(imageSize)" + (posterPath ?? "")
    }
    
    func composedBackdropPath() -> String? {
        guard let backdropPath = backdropPath else { return nil }
        return posterBaseURL + "\(imageSize)" + backdropPath
    }
    
    func formatRuntime() -> String {
        let totalHours = self.runtime?.minutesToHours(self.runtime ?? 0).hours
        let totalMinutes = self.runtime?.minutesToHours(self.runtime ?? 0).leftMinutes
        let formatedRuntime = "\(Int((totalHours) ?? 0))h" + " \(Int((totalMinutes) ?? 0))m"
        
        return formatedRuntime
    }
}
