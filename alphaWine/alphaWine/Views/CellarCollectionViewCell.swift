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
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var viewForCell: UIView!
    
    func updateCell(with wine: Wine){
        wineNameLabel.text = wine.name
        updateWineImage(with: wine.color!)
        overViewLabel.backgroundColor = Colors.darkGreen
        priceLabel.text = wine.price
        producerLabel.text = wine.producer
        summaryTextView.text = wine.summary
        notesTextView.text = wine.note
        viewForCell.backgroundColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 0.90)
        summaryTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        notesTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        
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
