//
//  Beverage.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation

struct JSONDictionary: Decodable {
    var result: [Beverage]
}

struct Beverage: Decodable {
    let name: String?
    let serving_suggestion: String?
    let tasting_note: String?
    let price_in_cents: Double?
    let style: String?
    let sugar_in_grams_per_liter: Int?
    let producer_name: String?
    let secondary_category: String?
    var image_url: URL?
    
}
