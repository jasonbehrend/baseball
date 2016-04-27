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
    var currentBatter: Batter?
    
    @IBOutlet weak var singlesLabel: UILabel!
    @IBOutlet weak var doublesLabel: UILabel!
    @IBOutlet weak var triplesLabel: UILabel!
    @IBOutlet weak var homerunsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let batterArray = NSUserDefaults.standardUserDefaults().arrayForKey(KEY_ALL_BATTERS){
            print("I got the array")
            batterNames = batterArray as! [String]
        }
        
        else {
            print("I couldn't get the array.")
        }
        
        if let batter_name = NSUserDefaults.standardUserDefaults().valueForKey(KEY_CURRENT_BATTER) as? String {
            print("Name is set: \(batter_name)")
            currentNameLabel.text = batter_name
            currentBatterName = batter_name
            
            getFirebaseData(batter_name)
            
        }

        else {
            print("no key")
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let _ = currentBatterName {

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
            
            // TODO: Be Sure A Name Was Entered - we don't want to create a new batter with an empty string
            
            // CREATE A NEW FIREBASE BATTER
            if let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
                
                print(uid)
                DataService.ds.createFirebaseBatter(uid, name: textField.text!)
                
                self.currentNameLabel.text = textField.text
                self.currentBatterName = textField.text
                self.batterNames.append(textField.text!)
                self.currentBatter = Batter(name: textField.text!)
                self.getFirebaseData(textField.text!)
                
                NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: KEY_CURRENT_BATTER)
                NSUserDefaults.standardUserDefaults().setObject(self.batterNames, forKey: KEY_ALL_BATTERS)
                
            }
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelButton)
        presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func userOptionsButton(sender: AnyObject) {
        
        // TODO: rename this function to something that makes more sense
        //   will need to unconnect it from storyboard first, then reconnect with new name
        
        let myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
        //let addBatterButton = UIAlertAction(title: "Add Batter", style: .Default, handler: )
        let addBatterButton = UIAlertAction(title: "Add Batter", style: .Default, handler: {
            (addBatterButton) -> Void in
            self.getBatterName("Add Batter", msg: "")
        })
        
        myActionSheet.addAction(addBatterButton)
        
        for batter in batterNames {
            
            let batterButton = UIAlertAction(title: batter, style: .Default, handler: {
                (batterButton) -> Void in
                
                self.showOrDelete(batter)

            })
            
            myActionSheet.addAction(batterButton)
        }
        
        
        myActionSheet.addAction(cancelButton)
        
        presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    func getFirebaseData(batter: String) {
        
        if let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
            
            DataService.ds.REF_USERS.childByAppendingPath(key).childByAppendingPath("Batters").childByAppendingPath(batter).observeEventType(.Value, withBlock: {
                
                snapshot in
                
                if let stats = snapshot.value as? Dictionary<String, AnyObject> {
                    
                    self.currentBatter = Batter(name: snapshot.key, stats: stats)
                    self.updateLabels(self.currentBatter!)
                    self.currentBatterName = self.currentBatter!.name
                    
                }
                
            })
            
        }
        
    }
    
    
    func updateLabels (batter: Batter) {
        singlesLabel.text = String(batter.singles)
        doublesLabel.text = String(batter.doubles)
        triplesLabel.text = String(batter.triples)
        homerunsLabel.text = String(batter.homeruns)
        
    }
    
    func showOrDelete (batter: String) {
        let showOrDeleteAlert = UIAlertController(title: "Show or Delete", message: "Do you want to show or delete this batter?", preferredStyle: .Alert)
        
        let showButton = UIAlertAction(title: "Show", style: .Default, handler:{
            (showButton) in
            
            self.currentBatterName = batter
            self.currentNameLabel.text = batter
            self.getFirebaseData(batter)
            NSUserDefaults.standardUserDefaults().setValue(batter, forKey: KEY_CURRENT_BATTER)
        })
        
        
        let deleteButton = UIAlertAction(title: "Delete", style: .Default, handler: {
            (batterButton) -> Void in
            
            let indexOfBatter = self.batterNames.indexOf(batter)
            
            if self.batterNames.endIndex == 1 {
                
                // TODO: don't change the batter unless it is the same one you deleted.
            
                print("Only one batter in the array")
                let oneBatterAlert = UIAlertController(title: "This Is The Only Batter", message: "You can't delete the only batter", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                oneBatterAlert.addAction(okButton)
                self.presentViewController(oneBatterAlert, animated: true, completion: nil)

                
                
            }
            
            else {
                
//                print("The batter to be deleted is \(batter)")
//                print("The current batter is \(self.currentBatter!.name)")
                
                
                // delete from array in this app
                self.batterNames.removeAtIndex(indexOfBatter!)
                
                // delete form Firebase
                DataService.ds.removeFirebaseBatter(batter)
                
                // delete from NSUserDefaults
                NSUserDefaults.standardUserDefaults().setObject(self.batterNames, forKey: KEY_ALL_BATTERS)
                
                
                // only change the current batter if that is who you're deleting
                if batter == self.currentBatter!.name{
                
                    // set current batter to the first person in the list
                    self.currentBatterName = self.batterNames[0]
                
                    // set NSUserDefaults current batter to above
                    NSUserDefaults.standardUserDefaults().setValue(self.currentBatterName, forKey: KEY_CURRENT_BATTER)
                    print("I set the NSUser to \(self.currentBatterName)")

                
                    // update the labels
                    self.currentNameLabel.text = self.currentBatterName
                    self.getFirebaseData(self.currentBatterName!)}
                

                
            }
            
            
        })
        
        showOrDeleteAlert.addAction(showButton)
        showOrDeleteAlert.addAction(deleteButton)
        presentViewController(showOrDeleteAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_ADDAB {
            if let destinationVC = segue.destinationViewController as? AddAtBatViewController {
                destinationVC.batter = currentBatter
            }
        }
    }

}
