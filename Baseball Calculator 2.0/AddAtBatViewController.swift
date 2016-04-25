//
//  AddAtBatViewController.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/29/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import UIKit
import Firebase

class AddAtBatViewController: UIViewController {
    
    var batter: Batter?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addSingle(sender: AnyObject) {
        
        print(batter!.name)
        
        if let currentBatter = batter {
            
            if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
                
                DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").childByAppendingPath(currentBatter.name).childByAppendingPath("singles").setValue(currentBatter.singles + 1)
                
                currentBatter.addSingle()
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func addDouble(sender: AnyObject) {
        
        if let currentBatter = batter {
            
            if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
                
                DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").childByAppendingPath(currentBatter.name).childByAppendingPath("doubles").setValue(currentBatter.doubles + 1)
                
                currentBatter.addDouble()
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addTriple(sender: AnyObject) {
        
        if let currentBatter = batter {
            
            if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
                
                DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").childByAppendingPath(currentBatter.name).childByAppendingPath("triples").setValue(currentBatter.triples + 1)
                
                currentBatter.addTriple()
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addHomeRun(sender: AnyObject) {
        
        if let currentBatter = batter {
            
            if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
                
                DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").childByAppendingPath(currentBatter.name).childByAppendingPath("homeruns").setValue(currentBatter.homeruns + 1)
                
                currentBatter.addHomeRun()
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    // TODO: make similar functions for addDouble, addTriple, etc, etc
    //   will also need to make methods in your Batter class (batter.swift) to update data in your model
    //   example: currentBatter.addDouble(), currentBatter.addOut(), currentBatter.addROE()
    //   
    // In your model (Batter.swift), you will need to add some more properties
    //   only make properties for things you can't calculate
    //   in other words, you need a property for at bats, but you don't need a property for hits
    //      because you can calculate hits by adding up singles, doubles, triples and homeruns
    //   you can also calculate average - so that doesn't need to be a property.  you can make a function to calculate it
    
}
