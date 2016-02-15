//
//  MaterialView.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/5/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 15.0
        layer.shadowOffset = CGSizeMake(0.0, 10.0)
        
    }

}