//
//  Genre+CoreDataProperties.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 16.09.2022.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension Genre : Identifiable {

}
