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

/// Class for the Home view
class HomeViewController: UIViewController{
    
    //----------------------------------------------------------------------------
    // MARK: Variables
    
    //Edit these articles to change the homepage articles.
    var article1 = Article(articleUrl: "https://today.cofc.edu/2019/04/18/college-of-charleston-virtual-tour/", imageUrl: "https://today.cofc.edu/wp-content/uploads/2018/07/cofc-campus.jpg", articleTitle: "CofC Virtual Tours")
    
      var article2 = Article(articleUrl: "https://today.cofc.edu/2020/04/23/stress-less-with-president-hsus-spring-finals-playlist/", imageUrl: "https://today.cofc.edu/wp-content/uploads/2020/04/Hsu.Playlist.TCT1_-800x533.jpg", articleTitle: "Dr. Hsu's Playlist")
    
      var article3 = Article(articleUrl: "https://today.cofc.edu/2020/04/24/cofc-campus-gets-refreshed-for-250th-anniversary/", imageUrl: "https://today.cofc.edu/wp-content/uploads/2020/03/IMG_5437-800x546.jpg", articleTitle: "Campus Refresh")
    
    //Creates the store variable
    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    //Creates the store variable used for firstLogin
    var storeO = SmartStore.shared(withName: SmartStore.defaultStoreName)
    let mylog = OSLog(subsystem: "edu.cofc.clyde", category: "Home")
    
    let defaults = UserDefaults.standard
    
    var userId = ""
    
    
    
    
    //----------------------------------------------------------------------------
    // MARK: Outlets
    
    //Outlet for the menu button.
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    @IBOutlet var homeView: UIView!
    
    @IBOutlet weak var Article1: UIButton!
    @IBOutlet weak var Article2: UIButton!
    @IBOutlet weak var Article3: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    
    
    //----------------------------------------------------------------------------
    // MARK: View Functions
    
    //Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarItem)
        self.addLogoToNav()
    
        
        
        //Change the image for Article1 here
        urlToButtonImage(imageUrlString: article1.imageUrl, button: Article1)
        
        //Change the image for Article2 here
        urlToButtonImage(imageUrlString: article2.imageUrl, button: Article2)
        
        //Change the image for Article3 here
        urlToButtonImage(imageUrlString: article3.imageUrl, button: Article3)
        
        label1.text = article1.articleTitle
        label2.text = article2.articleTitle
        label3.text = article3.articleTitle
        
        moreButton.layer.cornerRadius = 5
        moreButton.layer.borderWidth = 2
        moreButton.layer.borderColor = #colorLiteral(red: 0.558098033, green: 0.1014547695, blue: 0.1667655639, alpha: 1)
        if (defaults.object(forKey: "FirstLogin") == nil){
            self.showInformationPopUp()
        }
    }
    
    // Creates the view that the viewController manages
    override func loadView() {
        super.loadView()
        self.loadData()
        self.loadSchools()
        self.loadMajors()
        
    }
    
    // Notifies that the view controller is about to be added to memory
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    // MARK: Link functions
    
    /// Will present the article 1 webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickFirst(_ sender: UIButton) {
        show(article1.articleUrl)}
    
    /// Will present the article 2 webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickSecond(_ sender: UIButton) {
        show(article2.articleUrl)}
    
    /// Will present the article 3 webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickThird(_ sender: UIButton) {
        show(article3.articleUrl)}
    
    /// Will present the today.cofc when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickMore(_ sender: UIButton) {
        show("https://today.cofc.edu/")}
    
    
    /// Will present cofc's facebook page
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func showFacebook(_ sender: UIButton) {
        show("https://www.facebook.com/CofCAdmissions/")
    }
    
    
    /// Will present cofc's instagram page
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func showInstagram(_ sender: UIButton) {
        show("https://www.instagram.com/cofcadmissions/")
    }
    
    
    /// Will present cofc's twitter page
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func showTwitter(_ sender: UIButton) {
        show("https://twitter.com/cofcadmissions")
    }
    
    
    
//-----------------------------------------------------------------------
    // MARK: Helper functions

    
    
    /// Sets image for button using url
    /// - Parameters:
    ///   - imageUrlString: url of image
    ///   - image: imageView that needs to be set
    
    func urlToButtonImage(imageUrlString: String, button: UIButton){
        let url = URL(string: imageUrlString)!
        
        let task = URLSession.shared.dataTask(with: url){ data,response, error in
            guard let data = data, error == nil else {
                return}
            DispatchQueue.main.async {
                button.setImage(UIImage(data:data), for: .normal)
            }
        }
        task.resume()    }
    
    
    
    /// Shows the information pop up when called
    func showInformationPopUp(){
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoPop") as! InfoPopUpViewController
        popUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popUp, animated: true)
    }
    
    
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
    
    

    
 
    //-------------------------------------------------------------------------------
    // MARK: Salesforce related functions


    
    /// Loads salesforce data into store
    func loadData(){
        
        //Creation of the loading indicator 
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0);
        loadingIndicator.center = homeView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        loadingIndicator.backgroundColor = #colorLiteral(red: 0.3971119523, green: 0.3989546299, blue: 0.4034414291, alpha: 0.7198469606)
        loadingIndicator.layer.cornerRadius = 10

        homeView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        //Pulls the user info (specifically the id and email)
        let userIdRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userIdRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            let jsonResponse = JSON(response!)
            let id = jsonResponse["user_id"].stringValue
            let email = jsonResponse["email"].stringValue
            DispatchQueue.main.async {
                self?.userId = id
                self!.defaults.set(id,forKey: "UserId")
            }
            
            //Pulls the user info (specifically contactid)
            let userIdRequest = RestClient.shared.request(forQuery: "Select ContactId From User WHERE Id = '\(id)'")
            
            RestClient.shared.send(request: userIdRequest, onFailure: {(error, urlResponse) in
            }) { [weak self] (response, urlResponse) in
                guard let strongSelf = self,
                    let jsonResponse = response as? Dictionary<String, Any>,
                    let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                    else{
                        print("\nWeak or absent connection.")
                        return
                }

                let jsonContact = JSON(response!)
                let contactId = jsonContact["records"][0]["ContactId"].stringValue
                
                self!.defaults.set(contactId, forKey: "ContactId")
               

                
                //SalesforceLogger.d(type(of: strongSelf), message:"Invoked: \(userIdRequest)")
                if ((((strongSelf.store.soupExists(forName: "User"))))) {
                    strongSelf.store.clearSoup("User")
                    strongSelf.store.upsert(entries: results, forSoupNamed: "User")
                    os_log("\n\n----------------------SmartStore loaded records for user.-------------------------------", log: strongSelf.mylog, type: .debug)
                }
                
                //Loads contactData into store
                let contactAccountRequest = RestClient.shared.request(forQuery: "SELECT OwnerId, MailingStreet, MailingCity, MailingPostalCode, MailingState, MobilePhone, Email, Name, Text_Message_Consent__c, Birthdate, TargetX_SRMb__Gender__c,TargetX_SRMb__Student_Type__c, Gender_Identity__c, Ethnicity_Non_Applicants__c,TargetX_SRMb__Graduation_Year__c, Honors_College_Interest_Check__c,Status_Category__c,First_Login__c, TargetX_SRMb__Anticipated_Major__c,Id, AccountId  FROM Contact WHERE Email = '\(email)'")
                RestClient.shared.send(request: contactAccountRequest, onFailure: {(error, urlResponse) in
                    print(error)
                }) { [weak self] (response, urlResponse) in
                    guard let strongSelf = self,
                        let jsonResponse = response as? Dictionary<String, Any>,
                        let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                        else{
                            print("\nWeak or absent connection.")
                            return
                    }
                    print(results)

                    let jsonContact = JSON(response)
                    let counselorId = jsonContact["records"][0]["OwnerId"].stringValue
                    let state = jsonContact["records"][0]["MailingState"].stringValue
                    DispatchQueue.main.async {
                        self!.defaults.set(state,forKey: "State")

                    }
                    
                   // SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(contactAccountRequest)")
                    if (((strongSelf.store.soupExists(forName: "Contact")))){
                        strongSelf.store.clearSoup("Contact")
                        strongSelf.store.upsert(entries: results, forSoupNamed: "Contact")
                        os_log("\n\n----------------------SmartStore loaded records for contact.-------------------------------", log: strongSelf.mylog, type: .debug)
                    }
                    
                    //Loads counselor data into the store
                    print("\n\n\n")
                    print(counselorId)
                    print("\n\n\n")
                    let counselorAccountRequest = RestClient.shared.request(forQuery: "SELECT AboutMe, Email, Name,MobilePhone,Image_Url__c FROM User WHERE Id = '\(counselorId)'")
                    RestClient.shared.send(request: counselorAccountRequest, onFailure: {(error, urlResponse) in
                        print(error)
                    }) { [weak self] (response, urlResponse) in
                        guard let strongSelf = self,
                            let jsonResponse = response as? Dictionary<String, Any>,
                            let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                            else{
                                print("\nWeak or absent connection.")
                                return
                        }
                        print("\n\n\n")
                        print(jsonResponse)
                        print("\n\n\n")
                     //   SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(counselorAccountRequest)")
                        if (((strongSelf.store.soupExists(forName: "Counselor")))){
                            strongSelf.store.clearSoup("Counselor")
                            strongSelf.store.upsert(entries: results, forSoupNamed: "Counselor")
                            os_log("\n\n----------------------SmartStore loaded records for counselor.-------------------------------", log: strongSelf.mylog, type: .debug)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
            }
            
        }//completion
        
    }//func
        
    func loadMajors(){
        let majorRequest = RestClient.shared.request(forQuery: "SELECT Contact_Email__c,Description__c,Image_Url__c,Name,Website__c,Id FROM Possible_Interests__c WHERE Type__c = 'Major'")
        RestClient.shared.send(request: majorRequest, onFailure: {(error, urlResponse) in
            print(error)
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            // SalesforceLogger.d(type(of: strongSelf), message:"Invoked: \(userIdRequest)")
            if (((strongSelf.store.soupExists(forName: "Major")))) {
                strongSelf.store.clearSoup("Major")
                strongSelf.store.upsert(entries: results, forSoupNamed: "Major")
                os_log("\n\n----------------------SmartStore loaded records for majors.-------------------------------", log: strongSelf.mylog, type: .debug)
            }
            
           
        }
    }
    
    /// Loads school data into store
    func loadSchools(){
        let schoolRequest = RestClient.shared.request(forQuery: "SELECT Name, Id, BillingState, BillingCity From Account WHERE BillingState = '\(self.defaults.string(forKey: "State")!)'")
        RestClient.shared.send(request: schoolRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            print(results)

            if (((strongSelf.store.soupExists(forName: "School")))){
                strongSelf.store.clearSoup("School")
                strongSelf.store.upsert(entries: results, forSoupNamed: "School")
                os_log("\n\n----------------------SmartStore loaded records for school.-------------------------------", log: strongSelf.mylog, type: .debug)
                
            }
        }
    }
    
    
    /// Loads important data into the offline storage
    func loadDataIntoStore(){
        //Loads user id into store
        let userIdRequest = RestClient.shared.request(forQuery: "Select Name, Id, Email, ContactId From User")
        //let userIdRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userIdRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            
            

            SalesforceLogger.d(type(of: strongSelf), message:"Invoked: \(userIdRequest)")
            if ((((strongSelf.store.soupExists(forName: "User"))))) {
                strongSelf.store.clearSoup("User")
                strongSelf.store.upsert(entries: results, forSoupNamed: "User")
                os_log("\n\nSmartStore loaded records for user.", log: strongSelf.mylog, type: .debug)
            }

            //Loads contactData into store
            let contactAccountRequest = RestClient.shared.request(forQuery: "SELECT OwnerId, MailingStreet, MailingCity, MailingPostalCode, MailingState, MobilePhone, Email, Name, Text_Message_Consent__c, Birthdate, TargetX_SRMb__Gender__c,TargetX_SRMb__Student_Type__c, Gender_Identity__c, Ethnicity_Non_Applicants__c,TargetX_SRMb__Graduation_Year__c, Honors_College_Interest_Check__c,Status_Category__c,First_Login__c, TargetX_SRMb__Anticipated_Major__c,Id, AccountId  FROM Contact")
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
                let accountId = jsonContact["records"][0]["AccountId"].stringValue
                print("--------------------------------")
                print(accountId)
                SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(contactAccountRequest)")
                if (((strongSelf.store.soupExists(forName: "Contact")))){
                    strongSelf.store.clearSoup("Contact")
                    strongSelf.store.upsert(entries: results, forSoupNamed: "Contact")
                    os_log("\n\nSmartStore loaded records for contact.", log: strongSelf.mylog, type: .debug)
                }

                //Loads counselor data into the store
                let counselorAccountRequest = RestClient.shared.request(forQuery: "SELECT AboutMe, Email, Name,MobilePhone,Image_Url__c FROM User WHERE Id = '\(counselorId)'")
                RestClient.shared.send(request: counselorAccountRequest, onFailure: {(error, urlResponse) in
                }) { [weak self] (response, urlResponse) in
                    guard let strongSelf = self,
                        let jsonResponse = response as? Dictionary<String, Any>,
                        let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                        else{
                            print("\nWeak or absent connection.")
                            return
                    }
                    SalesforceLogger.d(type(of: strongSelf), message: "Invoked: \(counselorAccountRequest)")
                    if (((strongSelf.store.soupExists(forName: "Counselor")))){
                        strongSelf.store.clearSoup("Counselor")
                        strongSelf.store.upsert(entries: results, forSoupNamed: "Counselor")
                        os_log("\n\nSmartStore loaded records for counselor.", log: strongSelf.mylog, type: .debug)
                    }
                }
            }
        }
        
        let majorRequest = RestClient.shared.request(forQuery: "SELECT Contact_Email__c,Description__c,Image_Url__c,Name,Website__c,Id FROM Possible_Interests__c WHERE Type__c = 'Major'")
        RestClient.shared.send(request: majorRequest, onFailure: {(error, urlResponse) in
            print(error)
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            SalesforceLogger.d(type(of: strongSelf), message:"Invoked: \(userIdRequest)")
            if (((strongSelf.store.soupExists(forName: "Major")))) {
                strongSelf.store.clearSoup("Major")
                strongSelf.store.upsert(entries: results, forSoupNamed: "Major")
                os_log("\n\nSmartStore loaded records for majors.", log: strongSelf.mylog, type: .debug)
            }
        }    }
    
    


    /// Loads data from store and presents on edit profile
    /// Not in use
    func loadFromStore(){
        if  let querySpec = QuerySpec.buildSmartQuerySpec(smartSql: "select {Contact:First_Login__c} from {Contact}", pageSize: 1),
            let smartStore = self.storeO,
            let record = try? smartStore.query(using: querySpec, startingFromPageIndex: 0) as? [[String]]{
            let firstTime = (record[0][0])
            DispatchQueue.main.async {
                if firstTime == "0"{
                    self.showInformationPopUp()
                }
            }
        }
        }


    /// Pulls the url for the user's fullphotourl.
    /// Not in use
    func pullImage(){
        print("-----------------------------------------------------------")
        let id = defaults.string(forKey: "UserId")
        let userPhotoRequest = RestClient.shared.request(forQuery: "SELECT FullPhotoUrl FROM User WHERE Id = '\(id!)'")
        
        RestClient.shared.send(request: userPhotoRequest, onFailure: {(error, urlResponse) in
            print(error)
        }) { [weak self] (response, urlResponse) in
            guard let _ = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let _ = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            let jsonContact = JSON(response)
            let pictureUrl = jsonContact["records"][0]["FullPhotoUrl"].stringValue
            
            DispatchQueue.main.async {
                let sep = pictureUrl.components(separatedBy: "portal/")
                let url = "https://c.cs40.content.force.com/" + sep[1]
                
                self!.defaults.set(url, forKey: "ProfilePhotoURL")            }
            
        }
        
    }
    

}//class
    
    
       

    

