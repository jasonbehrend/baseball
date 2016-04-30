//
//  DataService.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/14/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://battingstats.firebaseio.com"

let NEW_BATTER_STATS_DICT = [
    "singles": 0,
    "doubles": 0,
    "triples": 0,
    "homeruns": 0,
    "outs": 0
]

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase{
        return _REF_USERS
    }

    func createFirebaseUser(uid: String, user: Dictionary <String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    func createFirebaseBatter(uid: String, name: String) {
        
        REF_USERS.childByAppendingPath(uid).childByAppendingPath("Batters").childByAppendingPath(name).setValue(NEW_BATTER_STATS_DICT)
    }
    
    func removeFirebaseBatter(name: String) {
        if let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
            REF_USERS.childByAppendingPath(uid).childByAppendingPath("Batters").childByAppendingPath(name).removeValue()
        }
    }
    
    
}