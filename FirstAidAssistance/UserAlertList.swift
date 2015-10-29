//
//  File.swift
//  FirstAidAssistance
//
//  Created by Jacques-Henri VANHAMME on 28/10/2015.
//  Copyright © 2015 Jacques-Henri VANHAMME. All rights reserved.
//

import Foundation

class UserAlertList{
    
    var AlertList = [Alert]()
    
    func count() -> Int{
        return AlertList.count
    }
    
}

class Alert{
    
    var userEmail: String?
    var userFirstName: String?
    var userTime: String?
    var userCondition: String?
    var userDescription: String?
    
    init(){
        userEmail = ""
        userFirstName = ""
        userTime =  ""
        userCondition = ""
        userDescription = ""
    }
    
    func getShortDescription() -> String{
        return userTime! + " ago, from " + userFirstName!
    }
    
    func getCondition() -> String{
        return userFirstName! + " requires your help.\n" + "His/Her condition is : " + userCondition! + ".\n\n" + "Here are some other information about him/her :\n" + userDescription!
    }
    
}