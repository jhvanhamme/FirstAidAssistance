//
//  File.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//


import UIKit
import CoreData

class RegisterPage2Controller: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{

    // Data from this page
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var RegisterPatientButton: UIButton!
    @IBOutlet weak var RegisterHealthKeeperButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var profileChoice: UIPickerView!
    @IBOutlet weak var OptionChoice: UIPickerView!
    @IBOutlet weak var userOptionChoice: UILabel!
    @IBOutlet weak var KmLabel: UILabel!
    @IBOutlet weak var KmInput: UITextField!
    var pickerData: [String] = [String]()
    var pickerOptionData: [String] = [String]()
    var choice: String = "Medicine Practitioner"
    var choiceOption: String = "Hospital Staff"
    var userFirstName: String = "";
    
    // Data from other pages
    var segueEmail: String!
    var seguePassword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLabel.text = segueEmail
        self.KmInput.delegate = self
        
        // Picker data initializer
        self.profileChoice.delegate = self
        self.profileChoice.dataSource = self
        pickerData = ["Medicine Practitioner","Patient"]
        
        self.OptionChoice.delegate = self
        self.OptionChoice.dataSource = self
        pickerOptionData = ["Hospital Staff", "Doctor", "Pharmacist", "Basic first aid trained"]

        // Main option -> Login as HealthKeeper
        RegisterPatientButton.hidden = true
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool
    {
        userText.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return pickerData.count
        }else{
            return pickerOptionData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1{
            choice = pickerData[row]
            pickerData = ["Medicine Practitioner","Patient"]
            
            if choice == "Medicine Practitioner"{
                RegisterPatientButton.hidden = true
                RegisterHealthKeeperButton.hidden = false
                KmLabel.hidden = false
                KmInput.hidden = false
                pickerOptionData = ["Hospital Staff", "Doctor", "Pharmacist", "Basic first aid trained"]
                self.OptionChoice.reloadAllComponents()
                userOptionChoice.text = "What's your training ?"
            }
            else if choice == "Patient"{
                RegisterPatientButton.hidden = false
                RegisterHealthKeeperButton.hidden = true
                KmLabel.hidden = true
                KmInput.hidden = true
                pickerOptionData = ["Heart issues", "Diabetes"]
                self.OptionChoice.reloadAllComponents()
                userOptionChoice.text = "What's your condition ?"
            }
            
            
        return pickerData[row]
            
        } else {
            choiceOption = pickerOptionData[row]
            return pickerOptionData[row]
        }
    }
    
    @IBAction func RegisterProfileInfo(sender: UIButton) {
        print("-> Register profile & description of the user")
        registerInfos()
    }
    
    @IBAction func RegisterProfileInfoForPatient(sender: UIButton) {
        print("-> Register profile & description of the user")
        registerInfos()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Switch segues & prepare data to push on next view
        print("OVERLOAD SEGUE", segue.identifier)
        print("debug:segueEmail", segueEmail)
        print("debug:seguePassword", seguePassword)
        
        // Prepare data to go to xxx page
        if(segue.identifier == "segueToPatient"){
            print("segueToPatient")
            (segue.destinationViewController as! HelpMePageController).segueLabel = segueEmail
            (segue.destinationViewController as! HelpMePageController).seguePassword = seguePassword
            (segue.destinationViewController as! HelpMePageController).segueFirstName = userFirstName
        }
        
        // Prepare data to go to xxx page
        if(segue.identifier == "segueToHK"){
            print("segueToHK")
            (segue.destinationViewController as! SupportPageController).segueEmail = segueEmail
            (segue.destinationViewController as! SupportPageController).seguePassword = seguePassword
        }
    }
    
    // DATA METHODS
    func registerInfos()->Int{
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext
        
        // Seek for User with this email address
        let reqGetUser = NSFetchRequest(entityName: "Users")
        reqGetUser.returnsObjectsAsFaults = false
        reqGetUser.predicate = NSPredicate(format: "userEmail = %@", segueEmail)
        print("Seeking for user =", segueEmail)
        
        do{
            let resultReq = try context.executeFetchRequest(reqGetUser)
            if(resultReq.count > 0){
                // Put user settings to data
                print("Choice UserMode = ",choice)
                resultReq.first!.setValue(choice, forKey: "userMode")
                resultReq.first!.setValue(descriptionInput.text, forKey: "userDescription")
                resultReq.first!.setValue(choiceOption, forKey: "userCondition")
                resultReq.first!.setValue(KmInput.text, forKey: "userMaxKM")
                userFirstName = resultReq.first!.valueForKey("userFirstName") as! String
                print("userFirstName = ", userFirstName)
                do {
                    try context.save()
                    return 0
                } catch {
                    print("Unable to set up your account")
                    return -1
                }
            }
            print("Unable to recover your account")
            return -1
        } catch {
            print("Unable to recover your account")
            return -1
        }
        
    }
    
}