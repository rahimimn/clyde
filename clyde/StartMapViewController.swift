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
    //Default user info storage
    let defaults = UserDefaults.standard
    //Inits a contactId to be set later
    var contactId = ""


//-----------------------------------------------------------------------
// MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //These are left removed
        //self.addLogoToNav()
        //self.menuBar(menuBarItem: menuBarButton)
        //Sets the contactId
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
    //Starts the interactive map
    @IBAction func startButton(_ sender: UIButton) {
       //print(getDate())
        //Registers the student for the event once the start button is pressed
        self.registerEvent()
    }
    
//-------------------------------------------------------------------------
// MARK: Salesforce Functions
    
    /// Registers the student for the 'Self Guided Tour' event
    func registerEvent(){
        do{
            let currentDate = getDate()
            
            //check if an OrgEvent self-guided tour exists for the current date
             let checkForExistingEvent = RestClient.shared.request(forQuery: "SELECT Id,Name,TargetX_Eventsb__Start_Time_TZ_Adjusted__c FROM TargetX_Eventsb__OrgEvent__c WHERE TargetX_Eventsb__Start_Time_TZ_Adjusted__c LIKE '%\(currentDate)%' AND Name LIKE 'Self%'")
            RestClient.shared.send(request: checkForExistingEvent, onFailure: {(error, urlResponse) in
                print(error)
            }) { [weak self](response, urlResponse) in
                let jsonResponse = JSON(response!)
                // if match exists, check if the student is registered. Else, create the event.
                // if registered, do nothing. Else, register the student.
                if (jsonResponse["totalSize"] == 1){
                    //if student is registered, do nothing.
                    //else, register the student
                    let eventOrgId = jsonResponse["records"][0]["Id"].stringValue
                    print(jsonResponse)
                    let studentId = self!.defaults.string(forKey: "ContactId")
                    _ = self!.isStudentRegistered(eventOrgId: eventOrgId, contactId: studentId!){ (status) in
                        print(status)
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
        RestClient.shared.send(request: registrationCheck, onFailure: {(error, urlResponse) in
            print(error)
        }) { [weak self](response, urlResponse) in
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
    
    /// Helper Salesforce method that actually registers the student
    ///
    /// - Parameters:
    ///   - eventOrgId: identification of event organization
    ///   - contactId: identification of student/contact
    func registerStudent(eventOrg: String, contactId: String){
        //Record for the student
        var createRecord = [String : Any]()
        createRecord["TargetX_Eventsb__Contact__c"] = contactId
        createRecord["TargetX_Eventsb__OrgEvent__c"] = eventOrg
        createRecord["TargetX_Eventsb__Confirmed__c"] = true
        createRecord["TargetX_Eventsb__Attended__c"] = true
        createRecord["TargetX_Eventsb__Number_of_Guests__c"] = 1
        
       //Creates the request to create
        let createRequest = RestClient.shared.requestForCreate(withObjectType: "TargetX_Eventsb__ContactScheduleItem__c", fields: createRecord)
        RestClient.shared.send(request: createRequest, onFailure: {(error, urlResponse) in
            print(error)
            //print("error in register student")
            //print("Student was not registered for event.")
        }) { (response, urlResponse) in
            //print("Student was registered for event.")
        }}
    
    
   
    
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
