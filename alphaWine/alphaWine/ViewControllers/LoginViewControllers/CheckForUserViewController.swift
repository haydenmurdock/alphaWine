//
//  CheckForUserViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/18/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class CheckForUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UserController.shared.fetchCurrentUser { (success) in
            DispatchQueue.main.async {
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let returningUserVC = storyboard.instantiateViewController(withIdentifier: "returningUser")
                    self.present(returningUserVC, animated: true, completion: nil)
                    
                }
                if !success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let signUpVC = storyboard.instantiateViewController(withIdentifier: "signUpVC")
                    self.present(signUpVC, animated: true, completion: nil)
                }
            }
        }
    }
}
        
        
        


