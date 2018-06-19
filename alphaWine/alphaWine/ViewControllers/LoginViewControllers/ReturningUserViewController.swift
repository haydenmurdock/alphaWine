//
//  ReturningUserViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/18/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class ReturningUserViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.backgroundImageView.loadGif(name: "background")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let loggedInUser = UserController.shared.loggedInUser else {return}
            
            self.welcomeLabel.text = "Welcome \(loggedInUser.username)"
        }
}
