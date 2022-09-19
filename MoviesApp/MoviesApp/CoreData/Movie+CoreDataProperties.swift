//
//  Movie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 16.09.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var originalTitle: String?
    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var runtime: Double
    @NSManaged public var genres: [Genre]?
}

extension Movie : Identifiable {

}
