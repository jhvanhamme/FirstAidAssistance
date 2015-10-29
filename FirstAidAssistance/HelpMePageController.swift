//
//  HelpMePageController.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 25/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class HelpMePageController: UIViewController, CLLocationManagerDelegate{
  
    let locationManager = CLLocationManager()
    
    // Data from another page
    var segueLabel: String!
    var seguePassword: String!
    var segueFirstName: String!
    
    // Data for this page
    @IBOutlet weak var DemoImgButton: UIButton!
    @IBOutlet weak var UserLabelX: UILabel!
    @IBOutlet weak var CallForHelpButton: UIButton!
    
    // View overload
    override func viewDidLoad() {
        super.viewDidLoad()
        DemoImgButton.hidden = true
        UserLabelX.text = segueLabel
        
        // Get Location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CallButton(sender: AnyObject) {
        // To Implement : Push notifications to other users
        print("CallForHelp Button -> No notifications implement")
        addAlert()
        
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
    
    // DATA METHODS
    func addAlert()->Int{
        
        // Check userInfo
        // Init Save data into CoreData
        let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDlg.managedObjectContext
        
        // Seek for User with this email address
        let reqGetUser = NSFetchRequest(entityName: "Users")
        reqGetUser.returnsObjectsAsFaults = false
        reqGetUser.predicate = NSPredicate(format: "userEmail = %@", segueLabel)
        print("Seeking for user =", segueLabel)
        
        do{
            let resultReq = try context.executeFetchRequest(reqGetUser)
            if(resultReq.count > 0){
                
                // Create new Alert

                // Init Save data into CoreData
                let appDlg:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDlg.managedObjectContext

                let alert = NSEntityDescription.insertNewObjectForEntityForName("Alerts", inManagedObjectContext: context) as NSManagedObject
                alert.setValue(segueLabel, forKey: "alertFromUserEmail")
                alert.setValue(segueFirstName, forKey: "alertFromUserFirstName")
                alert.setValue("0", forKey: "alertHasBeenTaken")
                alert.setValue(resultReq.first!.valueForKey("userDescription"), forKey: "alertFromUserDescription")
                alert.setValue(resultReq.first!.valueForKey("userCondition"), forKey: "alertFromUserCondition")
                
                // Get Current Location
                alert.setValue("Lille", forKey: "alertLocation")
                
                // getDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = dateFormatter.stringFromDate(NSDate())
                print("dateString = ", dateString)
                alert.setValue(dateString, forKey: "alertTime")
                
                // Save data
                do{
                    try context.save()
                    print("Alert created", alert)
                    return 0
                } catch {
                    print("Unable to create your alert")
                    return -1
                }
                
            }else{
                return -1
            }
        }
        catch{
            return -1
        }
        
    }
    
    // Location Methods
    
    // didUpdateLocations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
     
            if (error != nil) {
                print("Error:" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
                
            }else {
                print("Error with data")
                
            }
        })
    }
    
    // displayLocationInfo
    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
    }
    
    // didFailWithError
    func didFailWithError(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error: " + error.localizedDescription)
    }
}
