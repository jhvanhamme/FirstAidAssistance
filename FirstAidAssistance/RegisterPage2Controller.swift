//
//  File.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//


import UIKit

class RegisterPage2Controller: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    // Data from this page
    @IBOutlet weak var RegisterPatientButton: UIButton!
    @IBOutlet weak var RegisterHealthKeeperButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var profileChoice: UIPickerView!
    var pickerData: [String] = [String]()
    var choice: String!
    
    // Data from other pages
    var segueEmail: String!
    var seguePassword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print("Not implemented -> Register profile & description of the user")
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
        }
        
        // Prepare data to go to xxx page
        if(segue.identifier == "segueToHK"){
            print("segueToHK")
            (segue.destinationViewController as! SupportPageController).segueEmail = segueEmail
            (segue.destinationViewController as! SupportPageController).seguePassword = seguePassword
        }
    }
    
}