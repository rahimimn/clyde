//
//  CounselorViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import SwiftyJSON

class CounselorViewController: UIViewController {

    var name: String = ""
    var about: String = ""
    var email: String = ""
    var id: String = ""
    var studentID: String = ""
    
   
    @IBOutlet weak var counselorImage: UIImageView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var counselorEmail: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    
    //TO-DO: pull counselor information based on user, and then present name, contact email, and about me.
    
   
    
    func pullInformation(){
        
        //get user info
       let userRequest = RestClient.shared.requestForUserInfo()
       RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user info request: \(userRequest)")
        }) { [weak self] (response, urlResponse) in
           let userAccountJSON = JSON(response!)
           let userAccountID = userAccountJSON["user_id"].stringValue
        
            
        
        
        //Creates a request for the user's contact id, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (contactAccountId)
            let contactIDRequest = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = '\(userAccountID)'")
            RestClient.shared.send(request: contactIDRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactIDRequest)")
            }) { [weak self] (response, urlResponse) in
                let contactAccountJSON = JSON(response!)
                let contactAccountID = contactAccountJSON["records"][0]["ContactId"].stringValue
                
                
                // Creates a request for the user's counselor id, sends it, and saves json into response, uses SWIFTYJSON to convert needed data
                let counselorIDRequest = RestClient.shared.request(forQuery: "SELECT OwnerId FROM Contact WHERE Id = '\(contactAccountID)'")
                
                RestClient.shared.send(request: counselorIDRequest, onFailure: { (error, urlResponse) in
                    SalesforceLogger.d(type(of:self!), message:"Error invoking on counselor ID Request: \(counselorIDRequest)")
                }) { [weak self] (response, urlResponse) in
                    let counselorAccountJSON = JSON(response!)
                    let counselorId = counselorAccountJSON["records"][0]["OwnerId"]
                    
                    
                    //Creates a request for counselor info, and saves json into response, uses SWIFTYJSON to convert needed data
                    let counselorInfoRequest = RestClient.shared.request(forQuery: "SELECT AboutMe,Email,Name, FullPhotoUrl FROM User WHERE Id = '\(counselorId)'")
                    
                    RestClient.shared.send(request: counselorInfoRequest, onFailure: { (error, urlResponse) in
                        SalesforceLogger.d(type(of:self!), message:"Error invoking on counselor info Request: \(counselorInfoRequest)")
                    }) { [weak self] (response, urlResponse) in
                        let counselorInfoJSON = JSON(response!)
                        let counselorName = counselorInfoJSON["records"][0]["Name"].stringValue
                        let counselorAbout = counselorInfoJSON["records"][0]["AboutMe"].stringValue
                        let counselorEmail = counselorInfoJSON["records"][0]["Email"].stringValue
                        var counselorImageUrl = counselorInfoJSON["records"][0]["FullPhotoUrl"].stringValue
                        counselorImageUrl = counselorImageUrl.replacingOccurrences(of: "\"", with: "")
                        counselorImageUrl = counselorImageUrl.replacingOccurrences(of: "/clydeTest", with: "")
                        counselorImageUrl = "https://c.cs1.content.force.com\(counselorImageUrl)"
                        let url = URL(string: counselorImageUrl)!
                print("This is the image url \(url)")
                
                DispatchQueue.main.async {
                    self!.aboutMeText.text = counselorAbout
                    self!.name = counselorName
                    self!.counselorName.text = counselorName
                    self!.counselorEmail.text = counselorEmail
                    self!.contactLabel.text = "Contact Information"
                    self!.aboutLabel.text = "About"
                }//dispatch
                    }//counselor info
                }//counselor id
        }//contact
    }//user
    }
            
            
    override func viewDidLoad() {
        self.pullInformation()
        super.viewDidLoad()

    
        //reveals menu
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        
    }

}
