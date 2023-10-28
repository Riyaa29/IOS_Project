//
//  CocktailListViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import UIKit

// This class is the main cocktail list view controller
class CocktailListViewController: UITableViewController {
    
    // Declare a cocktails array to store cocktail models
    var cocktails: [CocktailModel] = []
    
    
    // viewDidLoad is called once the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigation back button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Fetch cocktail data
        fetchCocktails()
    }
    
    // Fetch cocktails from the API or local storage
    func fetchCocktails() {
        CocktailModel.fetchCocktails { (cocktails, error) in
            if let error = error {
                print("Error fetching cocktails: \(error)")
                return
            }
            guard let fetchedCocktails = cocktails else {
                print("No cocktails found")
                return
            }
            DispatchQueue.main.async {
                self.cocktails = fetchedCocktails
                self.tableView.reloadData()
            }
        }
    }
    
    // Set the number of rows in the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    // Configure the cells in the tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath)
        
        cell.backgroundColor = UIColor(red: 1.0, green: 0.41, blue: 0.71, alpha: 1.0) // Pink background
        cell.textLabel?.textColor = .white
        let mainIngredient = cocktails[indexPath.row].ingredients.first ?? "N/A"
        
        if let isLocal = cocktails[indexPath.row].isLocal, isLocal {
            cell.textLabel?.text = "\(indexPath.row + 1). \(cocktails[indexPath.row].name) - Main Ingredient: \(mainIngredient) "
        } else {
            cell.textLabel?.text = "\(cocktails[indexPath.row].id ?? "N/A"). \(cocktails[indexPath.row].name) - Main Ingredient: \(mainIngredient)"
        }
        
        return cell
    }
    
    
    // Prepare for segue to show cocktail details or add a new cocktail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "showCocktailDetail",
               let destinationViewController = segue.destination as? CocktailDetailViewController {
                destinationViewController.cocktail = cocktails[indexPath.row]
                
                if let isLocal = cocktails[indexPath.row].isLocal, isLocal {
                    destinationViewController.cocktailSource = .local
                } else {
                    destinationViewController.cocktailSource = .api
                }
            }
        } else if segue.identifier == "showAddCocktail",
                  let destinationViewController = segue.destination as? AddCocktailViewController {
            destinationViewController.completionHandler = { [weak self] newCocktail in
                self?.cocktails.append(newCocktail)
                self?.tableView.reloadData()
            }
        }
    }
    
    // Present the cocktail detail view controller with the selected cocktail
    func presentCocktailDetailViewController(with cocktail: CocktailModel) {
        if let cocktailDetailViewController = storyboard?.instantiateViewController(withIdentifier: "CocktailDetailViewController") as? CocktailDetailViewController {
            cocktailDetailViewController.cocktail = cocktail
            cocktailDetailViewController.cocktailSource = .local
            navigationController?.pushViewController(cocktailDetailViewController, animated: true)
        }
    }
    
    // viewWillAppear is called just before the view becomes visible on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the navigation bar title with the username if it exists
        if let username = UserDefaults.standard.string(forKey: "username") {
            self.navigationItem.title = "Hi, \(username)"
        } else {
            self.navigationItem.title = "Hi, User"
        }
    }
    
}
