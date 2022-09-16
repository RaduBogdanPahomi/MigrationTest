//
//  FavoriteMovie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 16.09.2022.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int64
    @NSManaged public var originalLamguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var runtime: Double
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
   
}

extension FavoriteMovie : Identifiable {
    func composedPosterPath() -> String {
        return posterBaseURL + "\(imageSize)" + (posterPath ?? "")
    }
    
    func composedBackdropPath() -> String? {
        guard let backdropPath = backdropPath else { return nil }
            
        return posterBaseURL + "\(imageSize)" + backdropPath
    }
}
