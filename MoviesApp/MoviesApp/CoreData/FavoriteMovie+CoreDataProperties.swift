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

    @NSManaged public var id: Int64
}

extension FavoriteMovie : Identifiable {
}
