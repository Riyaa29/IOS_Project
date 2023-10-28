//
//  UserExtension.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import Foundation
import CoreData

// This extension adds functionality to the User class to make it conform to the CoreDataProviderProtocol.
extension User : CoreDataProviderProtocol {
    
    static let entityName = "User"
    
    // Returns an array of all User objects in the given context.
    static func all( context : NSManagedObjectContext) -> [User] {
        
        return CoreDataProvider.all(context: context, entityName: User.entityName) as! [User]
        
    }
    
    // Saves the User object to the given context, returns the UUID of the saved object, or nil if save fails.
    func save(context: NSManagedObjectContext) -> UUID? {
        
        if self.id == nil {
            self.id = UUID()
        }
        
        do {
            try CoreDataProvider.save(context: context)
            return self.id
        } catch {
            return nil
        }
        
    }
    
    
    // Finds a User object in the given context with the specified username, returns the object if found, nil otherwise.
    static func findUserByUsername( context: NSManagedObjectContext, username : String ) -> User? {
        
        let allUsers = User.all(context: context)
        
        for user in allUsers {
            if user.username == username{
                return user// exit from the function
            }
        }
        return nil
    }
    
    // Authenticates a user with the given username and password in the given context, returns the authenticated user if successful, nil otherwise.
    static func loginAutentication( context: NSManagedObjectContext, username: String, password: String) -> User? {
        
        let allUsers = User.all(context: context)
        
        for user in allUsers{
            if user.username == username {
                if user.password == password {
                    return user
                }
            }
        }
        
        return nil
        
    }
    
}

