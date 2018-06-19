//
//  Wine.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import UIKit

class Wine: Equatable {

    let name: String
    var color: String
    var producer: String?
    var price: String?
    var image: UIImage?
    var summary: String?
    var note: String?
    
    
    init(name: String, color: String, producer: String, price: String, summary: String, note: String){
        self.name = name
        self.color = color
        self.producer = producer
        self.price = price
        self.summary = summary
        self.note = note

    }
    static func == (lhs: Wine, rhs: Wine) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color && lhs.producer == rhs.producer && lhs.price == lhs.price && lhs.summary == rhs.summary && lhs.note == rhs.note 
    }
}
