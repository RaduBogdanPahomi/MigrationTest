//
//  Movie+CoreDataClass.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 16.09.2022.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

public class Movie: NSManagedObject, Codable {
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
    
    private let imageSize = 500
    private let posterBaseURL = "https://image.tmdb.org/t/p/w"
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(id, forKey: .id)
            try container.encode(originalTitle, forKey: .originalTitle)
            try container.encode(adult, forKey: .adult)
            try container.encode(backdropPath, forKey: .backdropPath)
            try container.encode(originalLanguage, forKey: .originalLanguage)
            try container.encode(overview, forKey: .overview)
            try container.encode(popularity, forKey: .popularity)
            try container.encode(posterPath, forKey: .posterPath)
            try container.encode(releaseDate, forKey: .releaseDate)
            try container.encode(title, forKey: .title)
            try container.encode(video, forKey: .video)
            try container.encode(voteAverage, forKey: .voteAverage)
            try container.encode(voteCount, forKey: .voteCount)
            try container.encode(runtime, forKey: .runtime)
            try container.encode(genres, forKey: .genres)
            
        } catch(let error) {
            print("Encode error: \(error.localizedDescription)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Cannot get the contxt")
        }
        
        self.init(context: context)

        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            id = try values.decode(Int64.self, forKey: .id)
            originalTitle = try values.decode(String?.self, forKey: .originalTitle)
            adult = try values.decode(Bool.self, forKey: .adult)
            backdropPath = try values.decode(String?.self, forKey: .backdropPath)
            originalLanguage = try values.decode(String?.self, forKey: .originalLanguage)
            overview = try values.decode(String?.self, forKey: .overview)
            popularity = try values.decode(Double.self, forKey: .popularity)
            posterPath = try values.decode(String?.self, forKey: .posterPath)
            releaseDate = try values.decode(String?.self, forKey: .releaseDate)
            title = try values.decode(String?.self, forKey: .title)
            video = try values.decode(Bool.self, forKey: .video)
            voteAverage = try values.decode(Double.self, forKey: .voteAverage)
            voteCount = try values.decode(Int64.self, forKey: .voteCount)
            runtime = try values.decode(Double.self, forKey: .runtime)
//            genres = try values.decode([Genre]?.self, forKey: .genres)
        } catch(let error) {
            print("Decode Error: \(error.localizedDescription)")
        }
    }
    
    func composedPosterPath() -> String {
        return posterBaseURL + "\(imageSize)" + (posterPath ?? "")
    }
    
    func composedBackdropPath() -> String? {
        guard let backdropPath = backdropPath else { return nil }
            
        return posterBaseURL + "\(imageSize)" + backdropPath
    }
}
