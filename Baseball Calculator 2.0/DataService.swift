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

    func createFirebaseUser(uid: String, user: Dictionary <String, String>){
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}