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
    
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
//------------------------------------------------------------------------
// MARK: Button Function
    
    @IBAction func startButton(_ sender: UIButton) {
       print(getDate())
        self.registerEvent()
    }
    
//-------------------------------------------------------------------------
// MARK: Salesforce Functions
    
    /// Description
    func registerEvent(){
        do{
            let currentDate = getDate()
            
            //check if an OrgEvent self-guided tour exists for the current date
             let checkForExistingEvent = RestClient.shared.request(forQuery: "SELECT Id,Name,TargetX_Eventsb__Start_Time_TZ_Adjusted__c FROM TargetX_Eventsb__OrgEvent__c WHERE TargetX_Eventsb__Start_Time_TZ_Adjusted__c LIKE '%\(currentDate)%' AND Name LIKE 'Self%'")
            RestClient.shared.send(request: checkForExistingEvent, onFailure: {(error, urlResponse) in}) { [weak self](response, urlResponse) in
                let jsonResponse = JSON(response!)
                // if match exists, check if the student is registered. Else, create the event.
                // if registered, do nothing. Else, register the student.
                if (jsonResponse["totalSize"] == 1){
                    //if student is registered, do nothing.
                    //else, register the student
                    let eventOrgId = jsonResponse["records"][0]["Id"].stringValue
                    print(jsonResponse)
                    let studentId = self!.defaults.string(forKey: "ContactId")
                    let registrationStatus = self!.isStudentRegistered(eventOrgId: eventOrgId, contactId: studentId!){ (status) in
                    
                        if status == false {
                            self!.registerStudent(eventOrg: eventOrgId, contactId: studentId!)
                        }
                        else{
                            print("This student is registered.")
                        }
                    }
                }else{
                    print(jsonResponse)
                    print("This event does not exist.")
                }

            }
            
        }catch let e as Error?{
            print (e as Any)
        }
    }
    
    /// Helper Salesforce method that determines whether the contact id has the specific event-org id registered as a contact schedule item, using a closure
    ///
    /// - Parameters:
    ///   - eventOrgId: identification of event organization
    ///   - contactId: identification of student/contact
    
    func isStudentRegistered(eventOrgId: String, contactId: String, completion: @escaping (Bool) -> Void){
        let registrationCheck = RestClient.shared.request(forQuery:"SELECT Id FROM TargetX_Eventsb__ContactScheduleItem__c WHERE TargetX_Eventsb__Contact__c = '\(contactId)' AND TargetX_Eventsb__OrgEvent__c = '\(eventOrgId)'")
        RestClient.shared.send(request: registrationCheck, onFailure: {(error, urlResponse) in}) { [weak self](response, urlResponse) in
            let jsonResponse = JSON(response!)
            
            // if match exists, check if the student is registered. Else, create the event.
            // if registered, do nothing. Else, register the student.
            if (jsonResponse["totalSize"] == 0){
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func registerStudent(eventOrg: String, contactId: String){
        var createRecord = [String : Any]()
      createRecord["TargetX_Eventsb__Contact__c"] = contactId
        createRecord["TargetX_Eventsb__OrgEvent__c"] = eventOrg
        createRecord["TargetX_Eventsb__Confirmed__c"] = true
        createRecord["TargetX_Eventsb__Attended__c"] = true
        createRecord["TargetX_Eventsb__Number_of_Guests__c"] = 1
        
//        createRecord["Organization_Event__c"] = eventOrg
//        createRecord["Student__c"] = contactId
//        createRecord["Confirmed__c"] = true
//        createRecord["Attended__c"] = true
        
       //let createRequest = RestClient.shared.requestForCreate(withObjectType: "Campus_Tour__c", fields: createRecord)
        let createRequest = RestClient.shared.requestForCreate(withObjectType: "TargetX_Eventsb__ContactScheduleItem__c", fields: createRecord)
        RestClient.shared.send(request: createRequest, onFailure: {(error, urlResponse) in
            print(error)
            print("Student was not registered for event.")
        }) { [weak self] (response, urlResponse) in
            print("Student was registered for event.")
        }}
    
    
    
    
//
//        let currentDate = getDate()
//        //checks whether an OrgEvent Self-guided tour exists for the current date, if it is pulls the id
//        let checkForExistingEvent = RestClient.shared.request(forQuery: "SELECT Id,Name,TargetX_Eventsb__Start_Time_TZ_Adjusted__c FROM TargetX_Eventsb__OrgEvent__c WHERE TargetX_Eventsb__Start_Time_TZ_Adjusted__c LIKE '\(currentDate)%' AND Name LIKE 'Self%'")
//        RestClient.shared.send(request: checkForExistingEvent, onFailure: {(error, urlResponse) in}) { [weak self](response, urlResponse) in
//            let jsonResponse = JSON(response!)
//
//
//            let id = jsonResponse["records"][0]["Id"].stringValue
//
//
//            let checkForExistingSchedule = RestClient.shared.request(forQuery: "SELECT Id FROM TargetX_Eventsb__ContactScheduleItem__c WHERE TargetX_Eventsb__OrgEvent__c = '\(id)' AND TargetX_Eventsb__Contact__c = '\(self!.contactId)'")
//
//            RestClient.shared.send(request: checkForExistingSchedule, onFailure: {(error, urlResponse) in}) { [weak self] (response, urlResponse) in
//                let checkResponse = JSON(response!)
//                print("who are you")
//                print(checkResponse)
//                let results = jsonResponse.dictionaryObject
//                var createRecord = [String : Any]()
//                createRecord["TargetX_Eventsb__Contact__c"] = self?.contactId
//                createRecord["TargetX_Eventsb__OrgEvent__c"] = id
//                createRecord["TargetX_Eventsb__Confirmed__c"] = true
//                createRecord["TargetX_Eventsb__Attended__c"] = true
//                let totalSize = checkResponse["totalSize"].intValue
//                if (totalSize >= 1){
//                    ()
//                }
//                else{
//
//                   let createRequest = RestClient.shared.requestForCreate(withObjectType: "TargetX_Eventsb__ContactScheduleItem__c", fields: createRecord)
//                    RestClient.shared.send(request: createRequest, onFailure: {(error, urlResponse) in
//                        print(error)
//                        print(createRecord)
//                    }) { [weak self] (response, urlResponse) in
//                        print(createRecord)
//                }
//        }
//
//        }
//
//        }
        
    
    
//-------------------------------------------------------------------------
// MARK: Helper Functions
    
    /// This was adapted from the Apple Developer website documentation for the Date Formatter.
    ///
    /// It takes today's current date, and formats it for Salesforce. It is then returned.
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
        print(currentDate)
        return currentDate
    }
    
}
