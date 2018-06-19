//
//  LoginViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userNameTextField.center.x -= 500
        firstNameTextField.center.x -= 500
        lastNameTextField.center.x -= 500
        emailTextField.center.x -= 500
        
        userNameTextField.layer.cornerRadius = 10
        firstNameTextField.layer.cornerRadius = 10
        lastNameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.addDoneButtonOnKeyboard()
        firstNameTextField.addDoneButtonOnKeyboard()
        lastNameTextField.addDoneButtonOnKeyboard()
        emailTextField.addDoneButtonOnKeyboard()
        
        
      backgroundImageView.loadGif(name: "background")
    }
    

    @IBAction func createButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            self.userNameTextField.center.x += 500
        }
        UIView.animate(withDuration: 1.2) {
            self.firstNameTextField.center.x += 500
        }
        UIView.animate(withDuration: 1.4) {
            self.lastNameTextField.center.x += 500
        }
        UIView.animate(withDuration: 1.6) {
           self.emailTextField.center.x += 500
        }
        createButton.isHidden = true
        createButton.isUserInteractionEnabled = false
        finishButton.isHidden = false
        finishButton.isUserInteractionEnabled = true
        
    }
    
    
    
    
  
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text, userName.count > 0 else { return }
        guard let firstName = firstNameTextField.text, firstName.count > 0 else { return }
        guard let lastName = lastNameTextField.text, lastName.count > 0 else { return }
        guard let email = emailTextField.text, email.count > 0 else { return }
        
        UserController.shared.createnewUserWith(username: userName, firstname: firstName, lastName: lastName, email: email) { (success) in
            DispatchQueue.main.async {
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let returningUserVC = storyboard.instantiateViewController(withIdentifier: "returningUser")
                    self.present(returningUserVC, animated: true, completion: nil)
                }
            }
        }
    }
}

