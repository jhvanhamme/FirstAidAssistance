//
//  HelpMePageController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit
import CoreData

class HelpMePageController: UIViewController {
  
    // Data from another page
    var segueLabel: String!
    var seguePassword: String!
    
    // Data for this page
    @IBOutlet weak var DemoImgButton: UIButton!
    @IBOutlet weak var UserLabelX: UILabel!
    @IBOutlet weak var CallForHelpButton: UIButton!
    
    // View overload
    override func viewDidLoad() {
        super.viewDidLoad()
        DemoImgButton.hidden = true
        UserLabelX.text = segueLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CallButton(sender: AnyObject) {
        // To Implement : Push notifications to other users
        print("CallForHelp Button -> No notifications implement")
        
        // Call for emergency
        print("CallForHelp Button -> No caller app available")
        //let phoneNumber = "tel://0650578151"
        //let url:NSURL = NSURL(string: phoneNumber)!
        // UIApplication.sharedApplication().openURL(url)

        // Sample of call - Demo
        print("Waiting end of demo")
        CallForHelpButton.hidden = true
        DemoImgButton.hidden = false
    }
    
    @IBAction func StopDemo(sender: UIButton) {
        DemoImgButton.hidden = true
        CallForHelpButton.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Switch segues & prepare data to push on next view
        print(segue.identifier)
        
        // Prepare data to go to CallForHelp page
        if(segue.identifier == "segueToModifyMyProfile1Step"){
            print("segueToModifyMyProfile1Step")
            (segue.destinationViewController as! RegisterPageController).segueEmail = segueLabel
            (segue.destinationViewController as! RegisterPageController).seguePassword = seguePassword
        }
    }
}
