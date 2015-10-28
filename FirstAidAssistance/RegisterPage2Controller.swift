//
//  File.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//


import UIKit
import CoreData

class RegisterPage2Controller: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    // Data from this page
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var RegisterPatientButton: UIButton!
    @IBOutlet weak var RegisterHealthKeeperButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var profileChoice: UIPickerView!
    var pickerData: [String] = [String]()
    var choice: String = "Medecine Practitioner"
    var userFirstName: String = "";
    
    // Data from other pages
    var segueEmail: String!
    var seguePassword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLabel.text = segueEmail
        
        self.profileChoice.delegate = self
        self.profileChoice.dataSource = self
        pickerData = ["Medecine Practitioner","Patient"]
        // Main option -> Login as HealthKeeper
        RegisterPatientButton.hidden = true
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
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        choice = pickerData[row]
        if choice == "Medecine Practitioner"{
            RegisterPatientButton.hidden = true
            RegisterHealthKeeperButton.hidden = false
        }
        else {
            RegisterPatientButton.hidden = false
            RegisterHealthKeeperButton.hidden = true
        }
        
        return pickerData[row]
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