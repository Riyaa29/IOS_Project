//
//  LoginViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import CoreData
import UIKit

class LoginViewController: UIViewController {
    
    // Get context from AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Instance of CoreDataProvider
    let coreDataProvider = CoreDataProvider()
    
    // Outlets for text fields
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    // viewDidLoad is called once the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set secure text entry for password text field
        txtPassword.isSecureTextEntry = true
        
        // Create gradient layer for the background
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
        
        // Create a UIButton with the eye icon
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Add the eye icon to the right side of the password text field
        txtPassword.rightView = eyeButton
        txtPassword.rightViewMode = .always
    }
    
    // Login button action
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = txtUsername.text, !username.isEmpty,
              let password = txtPassword.text, !password.isEmpty else {
            showAlert(message: "Username or password cannot be empty")
            return
        }
        
        // Authenticate user
        if let user = User.loginAutentication(context: context, username: username, password: password) {
            print("User logged in: \(String(describing: user.username))")
            
            // Save the username to UserDefaults
            UserDefaults.standard.set(username, forKey: "username")
            
        } else {
            showAlert(message: "Invalid username or password")
        }
    }
    
    // Registration button action
    @IBAction func registrationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toRegistration", sender: self)
    }
    
    // Function to toggle password visibility
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        
    }
    
    // Function to show alert
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Update the gradient layer frame when the view layout changes
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let gradientLayer = self.view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.view.bounds
        }
    }
    
}



