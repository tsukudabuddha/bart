//
//  CoreDataStack.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/21/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataStack {
    static let instance = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "Favorite"
        )
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.viewContext
        return viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    func saveTo(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(context: NSManagedObjectContext, objectToDelete: NSManagedObject) {
        let fetchRequest = NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
        do {
            let result = try context.fetch(fetchRequest) as! FavoriteList
            for item in result.favorites! {
                if item.objectID == objectToDelete.objectID {
                    context.delete(objectToDelete)
                }
            }
            self.saveTo(context: context)
        } catch let error {
            print(error)
        }
    }
}
