//
//  DataManager.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import Foundation
import CoreData

class DataManager: NSObject {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrentNewsFeed")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let list = try persistentContainer.viewContext.fetch(request)
            return list
        } catch {
            print(error)
            return [T]()
        }
    }
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context Saved")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
