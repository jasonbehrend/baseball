//
//  Constants.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/5/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

// segues
let SEGUE_LOGGEDIN = "loggedIn"
let SEGUE_ADDAB = "AddAB"

// login status codes

let STATUS_INVALID_EMAIL = -5
let STATUS_INVALID_PWD = -6
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_NETWORK_ERROR = -15

//keys
let KEY_UID = "uid"
let KEY_CURRENT_BATTER = "current_batter_name"
let KEY_ALL_BATTERS = "key_all_batters"