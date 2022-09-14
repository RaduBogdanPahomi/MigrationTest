//
//  FavoriteMovie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.09.2022.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }
    
    @NSManaged public var name: String?
    
}

extension FavoriteMovie : Identifiable {

}
