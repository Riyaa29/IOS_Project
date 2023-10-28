//  AddCocktailViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import UIKit

// This class defines the AddCocktailViewController, responsible for
// allowing the user to add a new custom cocktail to the app.
class AddCocktailViewController: UIViewController {
    
    // Property to store the cocktail model
    var cocktail: CocktailModel?
    
    // Completion handler to update the cocktail list after adding a new cocktail
    var completionHandler: ((CocktailModel) -> Void)?
    
    // Outlets for UI elements on the screen
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var recipeTextField: UITextField!
    
    // Called when the view controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a gradient layer and set its frame to the view bounds
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        // Configure gradient colors and locations
        gradientLayer.colors = [
            UIColor(red: 0.25, green: 0.54, blue: 0.96, alpha: 0.6).cgColor,
            UIColor(red: 1.0, green: 0.41, blue: 0.71, alpha: 1.0).cgColor, // Pink
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1] // Update locations for three colors
        
        // Add gradient layer to the view
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Action for the save button tap
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let name = nameTextField.text ?? ""
        let ingredients = ingredientsTextField.text?.components(separatedBy: ", ") ?? []
        let recipe = recipeTextField.text ?? ""
        
        // Check if all fields are filled before saving the new cocktail
        if !name.isEmpty, !ingredients.isEmpty, !recipe.isEmpty {
            var newCocktail = CocktailModel(id: UUID().uuidString, name: name, ingredients: ingredients, recipe: recipe)
            newCocktail.isLocal = true
            completionHandler?(newCocktail)
            navigationController?.popViewController(animated: true)
        } else {
            // Show an alert if any field is empty
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // Action for the cancel button tap
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
