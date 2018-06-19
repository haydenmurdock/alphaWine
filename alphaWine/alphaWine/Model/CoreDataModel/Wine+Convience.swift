//
//  Wine+Convience.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/17/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import CoreData

extension Wine {
    convenience init(name: String, color: String, note: String, price: String, producer: String, summary: String, context: NSManagedObjectContext = CoreDataStack.context){
    self.init(context: context)
    self.name = name
    self.color = color
    self.note = note
    self.price = price
    self.producer = producer
    self.summary = summary
    
    }
}
