//
//  ViewController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit

class LoginPageController: UIViewController {

    // Inputs
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var ChoiceLabel: UILabel!
    
    // Buttons to navigate
    @IBOutlet weak var ConnectionButton: UIButton!
    @IBOutlet weak var SetUpProfileButton: UIButton!
    
    // Others
    var count: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Main option -> Login as registered user
        // Profile Set Up Button will disappear
        SetUpProfileButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check fields, if OK -> Go to Profile Set Up Page
    @IBAction func SetUpProfile(sender: UIButton) {
        if(checkFieldsOK()){
            print("InputFields OK -> SET UP PROFILE")
        }
    }
    
    // Check fields, if OK -> Go to Register Page
    @IBAction func Connection(sender: UIButton) {
        if(checkFieldsOK()){
            print("InputFields OK -> Connection")
        }
    }
    
    func createNewAlert(myTitle: String, myMessage: String, myPossibility: String){
        let alertController = UIAlertController(title: myTitle, message: myMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: myPossibility, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Tests fields of the form
    func checkFieldsOK() -> Bool{
        
        // Email is empty -> Error
        if (emailInput.text == "") {
            createNewAlert("Empty Field", myMessage: "Please enter email", myPossibility: "Accept")
            return false
        } else {
            if (emailInput.text?.containsString("@") == false){
                createNewAlert("Invalid Field", myMessage: "Please enter correct email", myPossibility: "Accept")
                return false
            }
        }
        
        // Password is empty -> Error
        if (passwordInput.text == "") {
            createNewAlert("Empty Field", myMessage: "Please enter password", myPossibility: "Accept")
            return false
        } else {
            if (passwordInput.text?.characters.count < 6){
                createNewAlert("Invalid Field", myMessage: "Password myst be 6 characters long minimum", myPossibility: "Accept")
                return false
            }
        }
        
        return true
    }
    
    // Set up the label avec UISwitch & let appear the good button for user's choice
    @IBAction func choiceSwitch(sender: UISwitch) {
        if count == 0 {
            count++
            ChoiceLabel.text = "Register"
            SetUpProfileButton.hidden = false
            ConnectionButton.hidden = true
            
        } else {
            count--
            ChoiceLabel.text = "Sign In"
            SetUpProfileButton.hidden = true
            ConnectionButton.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Switch segues & prepare data to push on next view
        
        // Prepare data to go to CallForHelp page
        if(segue.identifier == "segueToHelpMe"){
            print("segueToHelpMe")
            (segue.destinationViewController as! HelpMePageController).segueLabel = emailInput.text
            (segue.destinationViewController as! HelpMePageController).seguePassword = passwordInput.text
        }
        
        // Prepare data to go to CallForHelp page
        if(segue.identifier == "segueToRegister"){
            print("segueToRegister")
            (segue.destinationViewController as! RegisterPageController).segueEmail = emailInput.text
            (segue.destinationViewController as! RegisterPageController).seguePassword = passwordInput.text
        }
    }




}

