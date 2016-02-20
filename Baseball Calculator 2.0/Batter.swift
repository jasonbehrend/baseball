//
//  Batter.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/15/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import Foundation

class Batter {
    private var _name: String!
    private var _singles: Int!
    private var _doubles: Int!
    private var _triples: Int!
    private var _homeruns: Int!
    
    var name: String {
        return _name
    }
    
    var singles: Int {
        return _singles
    }
    
    var doubles: Int {
        return _doubles
    }
    
    var triples: Int {
        return _triples
    }
    
    var homeruns: Int {
        return _homeruns
    }
    
    init(name: String, stats: Dictionary<String, AnyObject>) {
        self._name = name
        
        if let singles = stats["singles"] as? Int {
            self._singles = singles
        }
        else {
            self._singles = 99
        }
        
        if let doubles = stats["doubles"] as? Int {
            self._doubles = doubles
        }
        
        if let triples = stats["triples"] as? Int {
            self._triples = triples
        }
        
        if let homeruns = stats["homeruns"] as? Int {
            self._homeruns = homeruns
        }
        
    }
    
}