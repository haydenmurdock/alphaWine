//
//  CustomTabBarView.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTabBarViewDelegate: class {
    func tabBarViewChangedSelectedIndex(at index: Int)
}

class CustomTabBarView: UIView {
    
  // Interface Builder Outlets
    
    
    weak var delegate: CustomTabBarViewDelegate?
    
    
    
}
