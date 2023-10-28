//
//  CocktailExtension.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//
import Foundation

// Extension for fetching CocktailModel objects from a remote JSON API.
struct CocktailModel: Codable {
    let id: String?
    let name: String
    let ingredients: [String]
    let recipe: String
    var isLocal: Bool?
}


extension CocktailModel {
    
    // Fetches an array of CocktailModel objects from a remote JSON API, calls the completion handler with the fetched data or an error if the fetch fails.
    static func fetchCocktails(completion: @escaping ([CocktailModel]?, Error?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Riyaa29/IOS_Project/cocktails"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil, NSError(domain: "Invalid URL", code: 1, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil, error)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil, NSError(domain: "No data received", code: 2, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode([CocktailModel].self, from: data)
                completion(fetchedData, nil)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    // Fetches a single CocktailModel object with the specified ID from a remote JSON API, calls the completion handler with the fetched data or an error if the fetch fails.
    static func fetchCocktailDetails(id: String, completion: @escaping (CocktailModel?, Error?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Riyaa29/IOS_Project/cocktails/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"]))
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let json = jsonObject as? [String: Any], json["id"] as? String == id else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"]))
                    return
                }
                
                
                let id = json["id"] as? String ?? ""
                let name = json["name"] as? String ?? ""
                let ingredients = json["ingredients"] as? [String] ?? []
                let recipe = json["recipe"] as? String ?? ""
                
                let cocktail = CocktailModel(id: id, name: name, ingredients: ingredients, recipe: recipe)
                completion(cocktail, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    
}
