//
//  CocktailDetailViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//
import UIKit

// This class defines the cocktail detail view controller, responsible for displaying
// detailed information about a specific cocktail.
class CocktailDetailViewController: UIViewController {
    
    // Properties to store the cocktail information and source of the cocktail data
    var cocktail: CocktailModel?
    var cocktailSource: CocktailSource = .api
    
    // Outlets for UI elements on the screen
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    
    // Called when the view controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the cocktail details based on the source of the data (API or local)
        switch cocktailSource {
        case .api:
            if let cocktailId = cocktail?.id {
                fetchCocktailDetailsFromAPI(cocktailId: cocktailId)
            }
        case .local:
            updateUI()
        }
    }
    
    
    // Fetch cocktail details from the API using the provided cocktail ID
    func fetchCocktailDetailsFromAPI(cocktailId: String) {
        CocktailModel.fetchCocktailDetails(id: cocktailId) { (fetchedCocktail, error) in
            if let error = error {
                print("Error fetching cocktail details: \(error)")
                return
            }
            
            guard let fetchedCocktail = fetchedCocktail else {
                print("No cocktail details found")
                return
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.cocktail = fetchedCocktail
                self.updateUI()
            }
        }
    }
    
    // Update the UI elements with the details of the cocktail
    func updateUI() {
        guard let cocktail = cocktail else { return }
        nameLabel.text = cocktail.name
        ingredientsLabel.text = cocktail.ingredients.joined(separator: "\n")
        recipeLabel.text = cocktail.recipe
    }
    
}
