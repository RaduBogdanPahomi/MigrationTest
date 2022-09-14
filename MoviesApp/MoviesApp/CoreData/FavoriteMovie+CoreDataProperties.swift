//
//  FavoriteMovie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 14.09.2022.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var originalTitle: String?
    @NSManaged public var id: Int64

}

extension FavoriteMovie : Identifiable {

}
