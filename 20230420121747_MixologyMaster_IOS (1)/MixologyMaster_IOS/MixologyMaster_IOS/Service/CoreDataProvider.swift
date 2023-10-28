//
//  UserProvider.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-15.
//
import CoreData
import UIKit


// This protocol defines methods for saving and deleting Core Data objects.
protocol CoreDataProviderProtocol {
    
    // Saves the object to the given context, returns the UUID of the saved object or nil if save fails.
    func save( context : NSManagedObjectContext) -> UUID?
    
    
    
}

class CoreDataProvider {
    
    // Returns an array of all objects of the specified entity in the given context.
    static func all( context : NSManagedObjectContext, entityName : String) -> [Any?] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : entityName)
        
        do {
            let allObjects = try context.fetch(request)
            return allObjects
        } catch {
            print("Exception at Fetch: \(error.localizedDescription)")
            return []
        }
        
    }
    
    // Saves changes to the given context, throws an error if save fails.
    static func save( context : NSManagedObjectContext) throws {
        
        do {
            try context.save()
        } catch {
            print("Exception at Save \(error.localizedDescription)")
            throw error
        }
        
    }
    
    
}
