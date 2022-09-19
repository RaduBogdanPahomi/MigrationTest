//
//  Genre+CoreDataClass.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 16.09.2022.
//
//

import Foundation
import CoreData


public class Genre: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
        } catch(let error) {
            print("Encode error: \(error.localizedDescription)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Cannot get the contxt")
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
    }
}
