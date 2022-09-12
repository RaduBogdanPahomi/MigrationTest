//
//  CoreDataStack.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.09.2022.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let storeContainer = NSPersistentContainer(name: self.modelName)
        storeContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return storeContainer
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

        func saveContext() {
            guard managedContext.hasChanges else { return }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
