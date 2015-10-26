//
//  SupportPageController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit
import CoreData

class SupportPageController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // Data from this page
    @IBOutlet weak var UserLabel: UILabel?
    @IBOutlet weak var ListOfCases: UITableView?
    var textCellIdentifier = "MyCells"
    var sampleListData: [String] = [String]()
    
    // Data from other pages
    var segueEmail: String = ""
    var seguePassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserLabel == nil){
            print("UILabel not initialized")
        } else {
            UserLabel!.text = segueEmail
        }
        
        // Demo data - Fill the list of cases
        if (ListOfCases == nil){
            print("ListOfCases not initialized")
        } else {
            ListOfCases!.delegate = self
            ListOfCases!.dataSource = self
            sampleListData = ["JH Vanhamme", "JEAN Decoster"]
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Switch segues & prepare data to push on next view
        print(segue.identifier)
        
        // Prepare data to go to CallForHelp page
        if(segue.identifier == "segueToModifyMyProfileFromHealthKeeper"){
            print("segueToModifyMyProfileFromHealthKeeper")
            (segue.destinationViewController as! RegisterPageController).segueEmail = segueEmail
            (segue.destinationViewController as! RegisterPageController).seguePassword = seguePassword
        }
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleListData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = sampleListData[row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(sampleListData[row])
    }
}
