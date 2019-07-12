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
    
   
    @IBOutlet var counselorView: UIView!
    @IBOutlet weak var counselorImage: UIImageView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var counselorEmail: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var instagramButton: UIButton!
    
    
    @IBAction func instagram(_ sender: UIButton) {
        
        show("https://www.instagram.com/cofcadmissions/")    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pullInformation()
        self.menuBar(menuBarItem: menuBarButton)
        
        
    }
   
    
    func pullInformation(){
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        loadingIndicator.center = counselorView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = #colorLiteral(red: 0.6127323508, green: 0.229350239, blue: 0.2821176946, alpha: 1)
        counselorView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        
        
        
        
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
                    let counselorInfoRequest = RestClient.shared.request(forQuery: "SELECT AboutMe,Email,Name,Phone,FullPhotoUrl FROM User WHERE Id = '\(counselorId)'")
                    
                    RestClient.shared.send(request: counselorInfoRequest, onFailure: { (error, urlResponse) in
                        SalesforceLogger.d(type(of:self!), message:"Error invoking on counselor info Request: \(counselorInfoRequest)")
                    }) { [weak self] (response, urlResponse) in
                        let counselorInfoJSON = JSON(response!)
                        let counselorName = counselorInfoJSON["records"][0]["Name"].stringValue
                        let counselorAbout = counselorInfoJSON["records"][0]["AboutMe"].stringValue
                        let counselorEmail = counselorInfoJSON["records"][0]["Email"].stringValue
                        let counselorPhone = counselorInfoJSON["records"][0]["Phone"].stringValue
                        var counselorImageUrl = counselorInfoJSON["records"][0]["FullPhotoUrl"].stringValue
                        counselorImageUrl = counselorImageUrl.replacingOccurrences(of: "\"", with: "")
                        counselorImageUrl = counselorImageUrl.replacingOccurrences(of: "/clydeTest", with: "")
                        
                
                DispatchQueue.main.async {
                    counselorImageUrl = "https://c.cs1.content.force.com/servlet/servlet.ImageServer?id=015S0000000x8nd&oid=00DS0000003Eiop&lastMod=1562873682000"  //"https://c.cs1.content.force.com\(counselorImageUrl)"
                    let url = URL(string: counselorImageUrl)!
                    
                    let task = URLSession.shared.dataTask(with: url){ data,response, error in
                        guard let data = data, error == nil else {return}
                        DispatchQueue.main.async {
                            self!.counselorImage.image = UIImage(data:data)
                        }
                    }
                    task.resume()
                    self!.aboutMeText.text = counselorAbout
                    self!.name = counselorName
                    self!.counselorName.text = counselorName
                    self!.counselorEmail.text = "Email: \(counselorEmail)"
                    self!.phoneText.text = "Phone: \(counselorPhone)"
                    self!.contactLabel.text = "Contact Information"
                    self!.aboutLabel.text = "About"
                    self!.header.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
                    self!.instagramButton.setTitle("@cofcadmissions", for: .normal)
                    loadingIndicator.stopAnimating()
                    
                }//dispatch
                    }//counselor info
                }//counselor id
        }//contact
    }//user
    }
            

    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }




}
