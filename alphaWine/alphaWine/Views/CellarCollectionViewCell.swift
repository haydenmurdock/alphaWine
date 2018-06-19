//
//  CellarCollectionViewCell.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class CellarCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var wineImageView: UIImageView!
    
    
    func updateCell(with wine: Wine){
        wineNameLabel.text = wine.name
        updateWineImage(with: wine.color!)
    }
    func updateWineImage(with color: String){
        if color == "Red"{
            wineImageView.image = UIImage(named: "redWineBottle")
        }
        if color == "White"{
            wineImageView.image = UIImage(named: "whiteWineBottle")
        }
        if color == "Sparkling" {
            wineImageView.contentMode = .scaleAspectFit
            wineImageView.image = UIImage(named: "sparklingWine")
        }
    }
}
