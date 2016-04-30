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
    private var _outs: Int!
    
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
    
    var outs: Int {
        return _outs
    }
    
    func addSingle() {
        self._singles = self._singles + 1
    }
    
    func addDouble() {
        self._doubles = self._doubles + 1
    }
    
    func addTriple() {
        self._triples = self._triples + 1
    }
    
    func addHomeRun() {
        self._homeruns = self._homeruns + 1
    }
    
    func addOut() {
        self._outs = self._outs + 1
    }
    
    func avg() -> String {
        let hits = Double(self._singles + self._doubles + self._triples + self._homeruns)
        let outs = Double(self._outs)
        // format avg will always make avg 3 digits long
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 3
        
        
        var avgWithoutPadding = 0.0
        if (hits + outs != 0) {
            avgWithoutPadding = (round(1000.0 * (hits / (hits + outs))) / 1000.0)
        }


        let avgWithPadding = formatter.stringFromNumber(avgWithoutPadding)
        
        if let avg = avgWithPadding {
            return avg
        }
        
        else {
            return "0.000"
        }

    }
    
    func slg() -> String {
        let totalBases = Double(self._singles + (2 * self._doubles) + (3 * self._triples) + (4 * self._homeruns))
        print(totalBases)
        let outs = Double(self._outs)
        let hits = Double(self._singles + self._doubles + self._triples + self._homeruns)
        print(hits)
        
        // format avg will always make avg 3 digits long
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 3
        
        var slgWithoutPadding = 0.0
        if (totalBases + outs != 0) {
            slgWithoutPadding = (round(1000.0 * (totalBases / (hits + outs))) / 1000.0)
        }
        
        let slgWithPadding = formatter.stringFromNumber(slgWithoutPadding)
        
        if let slg = slgWithPadding {
            return slg
        }
        
        else {
            return "0.000"
        }
    }
    
    
    init(name: String, stats: Dictionary<String, AnyObject>) {
        self._name = name
        
        if let singles = stats["singles"] as? Int {
            self._singles = singles
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
        
        if let outs = stats["outs"] as? Int {
            self._outs = outs
        }
        
    }
    
    init(name: String) {
        self._name = name
        
        self._singles = 0
        self._doubles = 0
        self._triples = 0
        self._homeruns = 0
        self._outs = 0
    }
    
}