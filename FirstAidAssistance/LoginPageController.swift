//
//  ViewController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit
import CoreData

class LoginPageController: UIViewController {
    
    
    // Inputs
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var ChoiceLabel: UILabel!
    @IBOutlet weak var MainConnectionButton: UIButton!
    
    // Buttons to navigate
    @IBOutlet weak var ConnectionButton: UIButton!
    @IBOutlet weak var SetUpProfileButton: UIButton!
    @IBOutlet weak var ConnectionToKHButton: UIButton!
    
    // Others
    var count: Int = 0;
    var userMode: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Main option -> Login as registered user
        // Profile Set Up Button will disappear
        SetUpProfileButton.hidden = true
        ConnectionToKHButton.hidden = true
        ConnectionButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    // Check fields, if OK -> Go to Profile Set Up Page
    @IBAction func SetUpProfile(sender: UIButton) {
        if(checkFieldsOK()){
            print("InputFields OK -> SET UP PROFILE")
            
            // Add the user in DB
            let userAdd: Int = addUser()
            if (userAdd < 0){
                print("User cant be added")
            }else{
                print("User has been created")
            }
        }
    }
    
    // Segue to Patient Side
    @IBAction func Connection(sender: UIButton) {
        print("Go To Patient Side")
    }
    
    // Segue to HG Side
    @IBAction func ConnectionToKH(sender: UIButton) {
        print("Go To HK Side")
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
            MainConnectionButton.hidden = true
        } else {
            count--
            ChoiceLabel.text = "Sign In"
            SetUpProfileButton.hidden = true
            MainConnectionButton.hidden = false
        }
    }
    
    // Launch one of the two Connection Button
    @IBAction func ConnectButton(sender: UIButton) {
        
        if(checkFieldsOK()){
            print("InputFields OK -> Connection")
            
            // Check for the user in DB
            let userExists: Int = searchUser()
            if (userExists < 0){
                print("User not found")
            }else if (userExists == 0){
                print("User found")
            }else{
                print("User found, but wrong password")
            }
            
            // Action to the button by UserMode
            if(userMode == "Medecine Practitioner"){
                //MainConnectionButton.addTarget(ConnectionToKHButton, action: "ConnectionToKH", forControlEvents: .TouchUpInside)
                performSegueWithIdentifier("segueToHKFromLogin", sender: sender)
            }else{
                //MainConnectionButton.addTarget(ConnectionButton, action: "Connection", forControlEvents: .TouchUpInside)
                performSegueWithIdentifier("segueToHelpMe", sender: sender)

            }
            
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
        
        // Prepare data to go to Register page
        if(segue.identifier == "segueToRegister"){
            print("segueToRegister")
            (segue.destinationViewController as! RegisterPageController).segueEmail = emailInput.text
            (segue.destinationViewController as! RegisterPageController).seguePassword = passwordInput.text
        }
        
        // Prepare data to go to Rescuer page
        if(segue.identifier == "segueToHKFromLogin"){
            print("segueToHKFromLogin")
            (segue.destinationViewController as! SupportPageController).segueEmail = emailInput.text!
            (segue.destinationViewController as! SupportPageController).seguePassword = passwordInput.text!
        }
    
    }
    
    // DATA METHODS BELOW
    
    func searchUser()->Int{
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext
        
        // Seek fo new User with this email address
        let reqGetUser = NSFetchRequest(entityName: "Users")
        reqGetUser.returnsObjectsAsFaults = false
        reqGetUser.predicate = NSPredicate(format: "userEmail = %@", emailInput.text!)
        print("Seeking for user =", emailInput.text!)
        
        do{
            var resultReq = try context.executeFetchRequest(reqGetUser)
            if(resultReq.count > 0){
                for row in resultReq{
                    print(row)
                }
                
                // Check for userPassword
                reqGetUser.predicate = NSPredicate(format: "userPassword = %@", passwordInput.text!)
                do{
                    resultReq = try context.executeFetchRequest(reqGetUser)
                    if (resultReq.count > 0) {
                        let user: NSManagedObject = resultReq.first as! NSManagedObject
                        // Check User Mode (Medecine or Patient) and actions the right buttons to go to his action page
                        // UserMode = 0 -> Patient
                        // UserMode = 1 -> Medecine Practitioner
                        userMode = user.valueForKey("userMode") as! String
                        return 0
                    }
                } catch {
                    createNewAlert("Invalid password", myMessage: "Your password seems wrong", myPossibility: "Retry")
                    return 1
                }
            }
            createNewAlert("User not found", myMessage: "Are you sure about your ids ?", myPossibility: "Retry")
            return -1
        } catch {
            createNewAlert("User not found", myMessage: "Are you sure about your ids ?", myPossibility: "Retry")
            return -1
        }
    }

    func addUser()->Int{
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext
        
        // Add new User
        let user = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as NSManagedObject
        user.setValue(emailInput.text, forKey: "userEmail")
        user.setValue(passwordInput.text, forKey: "userPassword")
        
        do{
            try context.save()
            return 0
        } catch {
            createNewAlert("DB Error", myMessage: "Unable to create your acount", myPossibility: "Retry")
            return -1
        }
    }

}

