//
//  enumSegue.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import Foundation

// This enum defines the various segues (transitions) between view controllers in the app.
enum Segue {
    
    // This segue takes the user to the login screen.
    static let toLogin = "toLogin"
    
    // This segue shows a list of cocktails.
    static let showCocktailList = "showCocktailList"
    
    // This segue shows the details of a specific cocktail.
    static let showCocktailDetail = "showCocktailDetail"
    
    // This segue takes the user to the screen for adding a new cocktail.
    static let showAddCocktail = "showAddCocktail"
    
    // This segue takes the user to the registration screen.
    static let toRegistration = "toRegistration"
    
    
}

