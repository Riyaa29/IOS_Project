//
//  RegistrationViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-16.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Set up the Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Declare the interface components
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var agreeToTermsSwitch: UISwitch!
    
    @IBOutlet weak var agreeToTermsLabel: UILabel!
    
    let genderPickerView = UIPickerView()
    let genderOptions = ["Male", "Female", "Other"]
    
    // viewDidLoad is called once the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text field delegates
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtFullName.delegate = self
        txtEmailAddress.delegate = self
        txtPhoneNumber.delegate = self
        
        // Set the password fields to be secure
        txtPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        txtGender.inputView = genderPickerView
        
        
        // Configure the UISwitch and UILabel for the "I agree to terms and conditions" statement
        agreeToTermsSwitch.isOn = false
        agreeToTermsLabel.text = "I agree to terms and conditions"
        agreeToTermsLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        agreeToTermsLabel.addGestureRecognizer(tapGestureRecognizer)
        
        // Configure and add the gradient layer to the view
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
        
        // Create UIButton with the eye icon for password and confirm password fields
        let passwordEyeButton = createEyeButton()
        let confirmPasswordEyeButton = createEyeButton()
        passwordEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        confirmPasswordEyeButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        
        // Add the eye icon to the right side of the password and confirm password text fields
        txtPassword.rightView = passwordEyeButton
        txtPassword.rightViewMode = .always
        txtConfirmPassword.rightView = confirmPasswordEyeButton
        txtConfirmPassword.rightViewMode = .always
    }
    
    @objc func termsLabelTapped() {
        // Toggle the UISwitch state when the UILabel is tapped
        agreeToTermsSwitch.isOn.toggle()
    }
    
    // Returns the number of columns in the UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of rows in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    // Returns the title for each row in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    // Handles the UIPickerView selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = genderOptions[row]
        txtGender.resignFirstResponder()
    }
    
    
    // Create the eye button for password visibility toggling
    func createEyeButton() -> UIButton {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return eyeButton
    }
    
    // Toggle password visibility for the password field
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
    }
    
    // Toggle password visibility for the confirm password field
    @objc func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtConfirmPassword.isSecureTextEntry = !txtConfirmPassword.isSecureTextEntry
    }
    // Handle the registration button tap event
    @IBAction func registrationButtonTapped(_ sender: Any) {
        // Validate that all fields have content
        guard let username = txtUsername.text, !username.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty,
              let fullName = txtFullName.text, !fullName.isEmpty,
              let emailAddress = txtEmailAddress.text, !emailAddress.isEmpty,
              let phoneNumber = txtPhoneNumber.text, !phoneNumber.isEmpty,
              let gender = txtGender.text, !gender.isEmpty else {
            // Display an error message if any of the fields are empty
            showAlert(message: "All fields are required")
            return
        }
        // Check if the password and confirm password fields match
        guard password == confirmPassword else {
            // Display an error message if the password and confirm password fields do not match
            showAlert(message: "Passwords do not match")
            return
        }
        
        // Check if the user already exists
        if let user = User.findUserByUsername(context: context, username: username) {
            Toast.ok(view: self, title: "Sorry", message: "User \(username) is already registered for \(user.fullName!)!", handler: nil)
            txtUsername.becomeFirstResponder() // set the focus
            return // exit from the function
        }
        
        // Check if the user has agreed to the terms and conditions
        guard agreeToTermsSwitch.isOn else {
            // Display an error message if the user has not agreed to the terms and conditions
            showAlert(message: "You must agree to the terms and conditions")
            return
        }
        
        // Create a new user and save it to the context
        let newUser = User(context: context)
        newUser.fullName = fullName
        newUser.username = username
        newUser.password = password
        newUser.emailAddress = emailAddress
        newUser.phoneNumber = phoneNumber
        newUser.gender = gender
        
        // Save the new user to the context
        if let _ = newUser.save(context: context) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Display an alert with a given message
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
