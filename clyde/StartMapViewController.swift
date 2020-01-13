//
//  StartMapViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 10/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SmartSync
import SwiftyJSON



class StartMapViewController: UIViewController {
    
//--------------------------------------------------------------------------
// MARK: Variables
    
    let defaults = UserDefaults.standard
    var contactId = ""


//-----------------------------------------------------------------------
// MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addLogoToNav()
        //self.menuBar(menuBarItem: menuBarButton)
        contactId = defaults.string(forKey: "ContactId")!
    }
    
//------------------------------------------------------------------------
// MARK: Button Function
    
    @IBAction func startButton(_ sender: UIButton) {
       print(getDate())
        self.registerEvent()
    }
    
//-------------------------------------------------------------------------
// MARK: Salesforce Functions
    
    func registerEvent(){
        
        let checkForExistingEvent = RestClient.shared.request(forQuery: "SELECT Id,Name,TargetX_Eventsb__Start_Time_TZ_Adjusted__c FROM TargetX_Eventsb__OrgEvent__c WHERE TargetX_Eventsb__Start_Time_TZ_Adjusted__c LIKE 'Jan 13, 2020%' AND Name LIKE 'Self%'")
        RestClient.shared.send(request: checkForExistingEvent, onFailure: {(error, urlResponse) in}) { [weak self](response, urlResponse) in
            let jsonResponse = JSON(response!)
            
         
            
            let id = jsonResponse["records"][0]["Id"].stringValue
           
            let checkForExistingSchedule = RestClient.shared.request(forQuery: "SELECT Id FROM TargetX_Eventsb__ContactScheduleItem__c WHERE TargetX_Eventsb__OrgEvent__c = '\(id)' AND TargetX_Eventsb__Contact__c = '\(self!.contactId)'")
               
            RestClient.shared.send(request: checkForExistingSchedule, onFailure: {(error, urlResponse) in}) { [weak self] (response, urlResponse) in
                let checkResponse = JSON(response!)
                print("who are you")
                print(checkResponse)
                let results = jsonResponse.dictionaryObject
                var createRecord = [String : Any]()
                createRecord["TargetX_Eventsb__Contact__c"] = self?.contactId
                createRecord["TargetX_Eventsb__OrgEvent__c"] = id
                createRecord["TargetX_Eventsb__Confirmed__c"] = true
                createRecord["TargetX_Eventsb__Attended__c"] = true
                let totalSize = checkResponse["totalSize"].intValue
                if (totalSize >= 1){
                    ()
                }
                else{
 
                   let createRequest = RestClient.shared.requestForCreate(withObjectType: "TargetX_Eventsb__ContactScheduleItem__c", fields: createRecord)
                    RestClient.shared.send(request: createRequest, onFailure: {(error, urlResponse) in
                        print(error)
                        print(createRecord)
                    }) { [weak self] (response, urlResponse) in
                        print(createRecord)
                }
        }
        
        }
        
        }
        
    }
    
//-------------------------------------------------------------------------
// MARK: Helper Functions
    
    /// This was adapted from the Apple Developer website documentation for the Date Formatter.
    ///
    /// It takes today's current date, and formats it for Salesforce. It is then returned/
    ///
    /// - Returns: current date
    func getDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let date = Date()
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        let currentDate = dateFormatter.string(from: date) // Oct 27, 2019
        return currentDate
    }
}
