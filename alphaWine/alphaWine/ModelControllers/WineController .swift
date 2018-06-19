//
//  WineController .swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import UIKit

class WineController {
    
    static let shared = WineController()
    
//CRUD

    func addWine(name: String, color: String, producer: String, price: String, summary: String, note: String){
        
    _ =  Wine(name: name, color: color, note: note, price: price, producer: producer, summary: summary)
    CoreDataStack.saveContext()
}
    
    
    func removeWinefromCoreData(with wine: Wine){
        CoreDataStack.context.delete(wine)
        CoreDataStack.saveContext()
    }
}
