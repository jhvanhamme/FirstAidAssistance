//
//  SupportPageController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SupportPageController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // Data from this page
    @IBOutlet weak var UserLabel: UILabel?
    @IBOutlet weak var ListOfCases: UITableView?
    var textCellIdentifier = "MyCells"
    @IBOutlet weak var PatientDescription: UITextView!
    var sampleListData = UserAlertList()
    @IBOutlet weak var MapButton: UIButton!
    var lastRow: NSIndexPath = NSIndexPath()
    var rowCpt = 0
    var userEmailAlert = ""
    
    // Data from other pages
    var segueEmail: String = ""
    var seguePassword: String = ""
    
    // takeIt Option
    var takeItUserEmail: String = ""
    var takeItUserLocation: String = ""
    
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
            checkForAlerts()
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
        return sampleListData.AlertList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = sampleListData.AlertList[row].getShortDescription()
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (rowCpt > 0){
            rowCpt++
            lastRow = indexPath
            tableView.deselectRowAtIndexPath(lastRow, animated: true)
        }
        
        let row = indexPath.row
        
        userEmailAlert = sampleListData.AlertList[row].userEmail!
        PatientDescription.text = sampleListData.AlertList[row].getCondition()
    }
    
    // DATA METHODS$
    func checkForAlerts(){
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext
        
        // Seek for User with this email address
        let reqGetAlerts = NSFetchRequest(entityName: "Alerts")
        reqGetAlerts.returnsObjectsAsFaults = false
        reqGetAlerts.predicate = NSPredicate(format: "alertHasBeenTaken = %@", "0")
        let sortDescriptor1 = NSSortDescriptor.init(key: "alertTime", ascending: false)
        let mySortDescriptors = [sortDescriptor1]
        reqGetAlerts.sortDescriptors = mySortDescriptors
        
        do{
            let resultReq = try context.executeFetchRequest(reqGetAlerts)
            // Put alerts info from data into the view
            if(resultReq.count > 0){
                for row in resultReq{
                    print(row)
                    
                    // Difference between alert date and current date
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let alertDate = dateFormatter.dateFromString(row.valueForKey("alertTime") as! String)
                    let alertDoubleResult = alertDate!.timeIntervalSinceNow
                    let alertIntResult = Int(alertDoubleResult) * -1
                    let (h, m, s) = convertToTime(alertIntResult)
                    print("alertDoubleResult = ", alertDoubleResult)
                    print("alertTimeResult = ", h, m, s)
                    
                    let newAlerte: Alert = Alert.init()
                    newAlerte.userEmail = row.valueForKey("alertFromUserEmail") as! String
                    newAlerte.userFirstName = row.valueForKey("alertFromUserFirstName") as! String
                    newAlerte.userDescription = row.valueForKey("alertFromUserDescription") as! String
                    newAlerte.userTime = String(m) + " min, " + String(s) + " scds"
                    newAlerte.userCondition = row.valueForKey("alertFromUserCondition") as! String
                    sampleListData.AlertList.append(newAlerte)
                }
            }
        } catch {
            print("Unable to recover alerts")
        }
    }
    
    func convertToTime(scd: Int)->(Int,Int,Int){
        return (scd / 3600, (scd % 3600) / 60, (scd % 3600) % 60)
    }
    
    func updateAlert(){
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext

        let reqGetAlerts = NSFetchRequest(entityName: "Alerts")
        reqGetAlerts.returnsObjectsAsFaults = false
        reqGetAlerts.predicate = NSPredicate(format: "alertHasBeenTaken = %@", "0")
        reqGetAlerts.predicate = NSPredicate(format: "alertFromUserEmail = %@", userEmailAlert)
        
        do{
            let resultReq = try context.executeFetchRequest(reqGetAlerts)
            // Put alerts info from data into the view
            if(resultReq.count > 0){
                resultReq.first!.setValue("1", forKey: "alertHasBeenTaken")
                try context.save()
            }
        } catch {
            print("Unable to set alert off")
        }
    }
    
    // MAP METHODS
    @IBAction func TakeIt(sender: UIButton) {
        let alert = UIAlertController.init(title: "Choose", message: "Action View", preferredStyle:UIAlertControllerStyle.ActionSheet)
        let firstAction = UIAlertAction.init(title: "Open in Maps", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.popupMap()
        }
        let secondAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Cancel")
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func popupMap(){
        //Set the alert has "taken"
        print("Set alert taken for = ", userEmailAlert)
        updateAlert()
        
        //coordinates for the place we want to display
        let rdOfficeLocation = CLLocationCoordinate2DMake(50.63301533411599,3.0188316106796265);
        let placemark = MKPlacemark.init(coordinate: rdOfficeLocation, addressDictionary: nil)
        let item = MKMapItem.init(placemark: placemark)
        item.name = "Ping";
        item.openInMapsWithLaunchOptions(nil)
    }
}
