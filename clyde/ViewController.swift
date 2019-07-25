//
//  ViewController.swift
//  clydeClubIos
//
//  Created by Rahimi, Meena Nichole (Student) on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON
import SalesforceSDKCore
import SmartSync
import SmartStore


class HomeViewController: UIViewController{

    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    let mylog = OSLog(subsystem: "edu.cofc.club.clyde", category: "profile")

    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarItem)
        
    }
    
    override func loadView() {
        super.loadView()
        loadDataIntoStore()
    }
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickFirst(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/24/beat-the-heat-public-health-heat-related-illness/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickSecond(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/21/jarrell-brantley-nba-draft/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickThird(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/12/college-of-charleston-orientation-2019/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickMore(_ sender: UIButton) {
        show("https://today.cofc.edu/")}
    
    
    /// Displays the url as a Safari view controller
    ///
    /// - Parameter url: the url to be displayed.
    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
    /// Loads important data into the offline storage
    func loadDataIntoStore(){
        //Loads user id into store
        let userIdRequest = RestClient.shared.request(forQuery: "Select Name, Id, Email, ContactId From User")
        RestClient.shared.send(request: userIdRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
            let jsonResponse = response as? Dictionary<String, Any>,
            let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            print(results)
            SalesforceLogger.d(type(of: strongSelf), message:"Invoked: \(userIdRequest)")
            if ((strongSelf.store.soupExists(forName: "User"))) {
                strongSelf.store.clearSoup("User")
                strongSelf.store.upsert(entries: results, forSoupNamed: "User")
                os_log("\n\nSmartStore loaded records for user.", log: strongSelf.mylog, type: .debug)
            }
        
            //Loads contactData into store
            let contactAccountRequest = RestClient.shared.request(forQuery: "SELECT OwnerId, MailingStreet, MailingCity, MailingPostalCode, MailingState, MobilePhone, Email, Name, Text_Message_Consent__c, Birthdate, TargetX_SRMb__Gender__c, TargetX_SRMb__Student_Type__c, Gender_Identity__c, Ethnicity_Non_Applicants__c,TargetX_SRMb__Graduation_Year__c, Honors_College_Interest__c FROM Contact")
            RestClient.shared.send(request: contactAccountRequest, onFailure: {(error, urlResponse) in
            }) { [weak self] (response, urlResponse) in
                guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                    else{
                        print("\nWeak or absent connection.")
                        return
                }
               
                let jsonContact = JSON(response)
                let counselorId = jsonContact["records"][0]["OwnerId"].stringValue
                SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(contactAccountRequest)")
                if ((strongSelf.store.soupExists(forName: "Contact"))){
                    strongSelf.store.clearSoup("Contact")
                    strongSelf.store.upsert(entries: results, forSoupNamed: "Contact")
                    os_log("\n\nSmartStore loaded records for contact.", log: strongSelf.mylog, type: .debug)
                }
                print(counselorId)
                
                //Loads counselor data into the store
                let counselorAccountRequest = RestClient.shared.request(forQuery: "SELECT AboutMe, Email, Name,Phone,MediumPhotoUrl FROM User WHERE Id = '\(counselorId)'")
                RestClient.shared.send(request: counselorAccountRequest, onFailure: {(error, urlResponse) in
                }) { [weak self] (response, urlResponse) in
                    guard let strongSelf = self,
                        let jsonResponse = response as? Dictionary<String, Any>,
                        let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                        else{
                            print("\nWeak or absent connection.")
                            return
                    }
                    print(jsonResponse)
                    SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(counselorAccountRequest)")
                    if ((strongSelf.store.soupExists(forName: "Counselor"))){
                        strongSelf.store.clearSoup("Counselor")
                        strongSelf.store.upsert(entries: results, forSoupNamed: "Counselor")
                        os_log("\n\nSmartStore loaded records for counselor.", log: strongSelf.mylog, type: .debug)
                    }
                }
            }
        }
    }

    
    
    









}//class
    
    
       

    

