//
//  Favorite+CoreDataProperties.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 19.09.2022.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64

}

extension Favorite : Identifiable {

}
