//
//  WineCell.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class WineCell: UITableViewCell {

    
 
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var tastingNotesTextView: UITextView!
    
    var beverage: Beverage? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
    }
}
