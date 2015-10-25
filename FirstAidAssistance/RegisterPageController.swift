//
//  RegisterPageController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit

class RegisterPageController: UIViewController {
    
    // Data for this page
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var LastNameInput: UITextField!
    @IBOutlet weak var FirstNameInput: UITextField!
    var countAge: Int = 0;
    var countAgree: Int = 0;
    
    // Data from othe pages
    var segueEmail: String!
    var seguePassword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Main option -> Login as registered user
        self.EmailInput.text = segueEmail
        self.PasswordInput.text = seguePassword
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle UISwith values
    @IBAction func SwitchAgree(sender: UISwitch) {
        if countAgree == 0 {
            countAgree++
            
        } else {
            countAgree--
        }
    }
    
    @IBAction func SwitchAge(sender: UISwitch) {
        if countAge == 0 {
            countAge++
            
        } else {
            countAge--
        }
    }
    
    @IBAction func RegisterAction(sender: UIButton) {
        // Check Inputs
        var inputsAreOK: Bool = true
        inputsAreOK = checkFieldsOK()
        
        // Check UISwitchs
        if(countAge != 0){
            inputsAreOK = false;
            createNewAlert("User not agree with App", myMessage: "You can't register if you're under 18", myPossibility: "Accept")
        }
        if(countAgree != 0){
            inputsAreOK = false;
            createNewAlert("User not agree with App", myMessage: "You must agree with terms of this App", myPossibility: "Accept")
        }
        
        //
        if(inputsAreOK){
           print("Not implemented -> Register user infos")
        }
    }
    
    // Tests fields of the form
    func checkFieldsOK() -> Bool{
        
        // Email is empty -> Error
        if (EmailInput.text == "") {
            createNewAlert("Empty Field", myMessage: "Please enter email", myPossibility: "Accept")
            return false
        } else {
            if (EmailInput.text?.containsString("@") == false){
                createNewAlert("Invalid Field", myMessage: "Please enter correct email", myPossibility: "Accept")
                return false
            }
        }
        
        // Password is empty -> Error
        if (PasswordInput.text == "") {
            createNewAlert("Empty Field", myMessage: "Please enter password", myPossibility: "Accept")
            return false
        } else {
            if (PasswordInput.text?.characters.count < 6){
                createNewAlert("Invalid Field", myMessage: "Password myst be 6 characters long minimum", myPossibility: "Accept")
                return false
            }
        }
        
        return true
    }
    
    func createNewAlert(myTitle: String, myMessage: String, myPossibility: String){
        let alertController = UIAlertController(title: myTitle, message: myMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: myPossibility, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Switch segues & prepare data to push on next view
        
        // Prepare data to go to CallForHelp page
        if(segue.identifier == "segueToProfile2"){
            print("segueToProfile2")
            (segue.destinationViewController as! RegisterPage2Controller).segueEmail = segueEmail
            (segue.destinationViewController as! RegisterPage2Controller).seguePassword = seguePassword
        }
    }
    
}
