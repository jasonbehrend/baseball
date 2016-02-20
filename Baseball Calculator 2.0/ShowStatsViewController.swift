//
//  ShowStatsViewController.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/15/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import UIKit
import Firebase

class ShowStatsViewController: UIViewController {
    
    @IBOutlet weak var currentNameLabel: UILabel!
    
    var currentBatterName: String?
    
    var batterNames = [String]()
    
    @IBOutlet weak var singlesLabel: UILabel!
    @IBOutlet weak var doublesLabel: UILabel!
    @IBOutlet weak var triplesLabel: UILabel!
    @IBOutlet weak var homerunsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setValue("ad313d21-6bb5-43b4-a8b4-67137e19381d", forKey: KEY_UID)
        
        
        if let batterArray = NSUserDefaults.standardUserDefaults().arrayForKey(KEY_ALL_BATTERS){
            //print("I got the array")
            batterNames = batterArray as! [String]
        }
        
        else{
            //print("I couldn't get the array.")
        }
        
        
        if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
            
            DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").observeEventType(.Value, withBlock: {
            
                snapshot in
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    
                    for snap in snapshots {
                        print(snap)
                        print("current Batter \(self.currentBatterName)")
                        
                        // check if this snap represents our current batter
                        if snap.key == self.currentBatterName {
                            if let stats = snap.value as? Dictionary<String, AnyObject> {
                                let currentBatter = Batter(name: snap.key, stats: stats)
                                self.updateLabels(currentBatter)
                            }
                        }
                    }
                    
                }
            
            })
        }
        else {
            print("no key")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
       
        if let batter_key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_CURRENT_BATTER) as? String {
            print("Name is set")
            currentNameLabel.text = batter_key
        }
            
        else {
            getBatterName("No Name Detected", msg: "Please enter a name")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getBatterName(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        //Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Enter name here."
        })
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            //print("Textfield: \(textField.text)")
            
            // CREATE A NEW FIREBASE BATTER
            
            self.currentNameLabel.text = textField.text
            self.currentBatterName = textField.text
            self.batterNames.append(textField.text!)
            self.getFirebaseData(self.currentBatterName!)
            NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: KEY_CURRENT_BATTER)
            NSUserDefaults.standardUserDefaults().setObject(self.batterNames, forKey: KEY_ALL_BATTERS)
            
            // test code to get array out of nsuserdefaults
            // let myarray = NSUserDefaults.standardUserDefaults().arrayForKey(KEY_ALL_BATTERS)
        })
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func userOptionsButton(sender: AnyObject) {
        
        let myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
        //let addBatterButton = UIAlertAction(title: "Add Batter", style: .Default, handler: )
        let addBatterButton = UIAlertAction(title: "Add Batter", style: .Default, handler: {
            (addBatterButton) -> Void in
            self.getBatterName("Add Batter", msg: "")
        })
        
        myActionSheet.addAction(addBatterButton)
        
        for batter in batterNames {
//            print(batter)
            
            let batterButton = UIAlertAction(title: batter, style: .Default, handler: {
                (batterButton) -> Void in
                
                self.currentBatterName = batter
                self.currentNameLabel.text = batter
                self.getFirebaseData(batter)
            })
            
            myActionSheet.addAction(batterButton)
        }
        
        
        myActionSheet.addAction(cancelButton)
        
        presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    func getFirebaseData(batter: String) {
        if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {

            DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").observeEventType(.Value, withBlock: {
                
                snapshot in
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    
                    for snap in snapshots {
                        
                        // check if this snap represents our current batter
                        if snap.key == self.currentBatterName {
                            print(snap)
                            if let stats = snap.value as? Dictionary<String, AnyObject> {
                                let currentBatter = Batter(name: snap.key, stats: stats)
                                self.updateLabels(currentBatter)
                            }
                        }
                    }
                    
                }
                
            })
        }
        else {
            print("no key")
        }
    }
    
    
    func updateLabels (batter: Batter) {
        singlesLabel.text = String(batter.singles)
        doublesLabel.text = String(batter.doubles)
        triplesLabel.text = String(batter.triples)
        homerunsLabel.text = String(batter.homeruns)
        
    }

}
