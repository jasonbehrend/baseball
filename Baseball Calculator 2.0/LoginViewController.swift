//
//  LoginViewController.swift
//  Baseball Calculator 2.0
//
//  Created by Jason Behrend on 2/14/16.
//  Copyright © 2016 JasonBehrend. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if DataService.ds.REF_BASE.authData != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true;
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    @IBAction func login(sender: AnyObject) {
        print("Login Called")
        
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    //there is an error, let's see what it was
                    switch error.code {
                    case STATUS_INVALID_EMAIL:
                        self.showErrorAlert("Invalid Email", msg: "Please enter a valid email address")
                    case STATUS_INVALID_PWD:
                        self.showErrorAlert("Invalid Password", msg: "Passowrd is not correct")
                    case STATUS_NETWORK_ERROR:
                        self.showErrorAlert("Network Error", msg: "Sorry, there is no internet connection available to make a new account.")
                    case STATUS_ACCOUNT_NONEXIST:
                        // account does not exist, let's make a new account
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { err, result in
                            
                            if err != nil {
                                self.showErrorAlert("Unable to Create Account", msg: "Error creating account. Eror code \(err.code)")
                            }
                            else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                                    
                                    let user = ["email": email]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                            }
                            
                        })
                    default:
                        print(error)
                        
                        
                    }
                }
                
                else {
                    // authUser succeeded, so we should perform segue
                    self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                }

        
            })
        }
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    

}
