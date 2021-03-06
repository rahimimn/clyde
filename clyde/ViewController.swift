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
    
    //Standard user defaults variable
    let defaults = UserDefaults.standard
    
    var userId = ""
    
    
    
    
    //----------------------------------------------------------------------------
    // MARK: Outlets
    
    //Outlet for the more button.
    @IBOutlet weak var moreButton: UIButton!
    //Outlet for the menu button
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    //Outlet for the controller's view
    @IBOutlet var homeView: UIView!
    
    //Outlets for all of the buttons of the articles
    @IBOutlet weak var Article1: UIButton!
    @IBOutlet weak var Article2: UIButton!
    @IBOutlet weak var Article3: UIButton!
    
    //Outlets for all of the labels of the articles.
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    
    
    //----------------------------------------------------------------------------
    // MARK: View Functions
    
    //Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        //function that adds the menu bar to the view
        self.menuBar(menuBarItem: menuBarItem)
        //adds the College of Charleston logo to the menu bar
        self.addLogoToNav()
    
        
        
        //Change the image for Article1 here
        urlToButtonImage(imageUrlString: article1.imageUrl, button: Article1)
        
        //Change the image for Article2 here
        urlToButtonImage(imageUrlString: article2.imageUrl, button: Article2)
        
        //Change the image for Article3 here
        urlToButtonImage(imageUrlString: article3.imageUrl, button: Article3)
        
        //Sets the titles for the article labels
        label1.text = article1.articleTitle
        label2.text = article2.articleTitle
        label3.text = article3.articleTitle
        
        //Sets the border "css"
        moreButton.layer.cornerRadius = 5
        moreButton.layer.borderWidth = 2
        moreButton.layer.borderColor = #colorLiteral(red: 0.558098033, green: 0.1014547695, blue: 0.1667655639, alpha: 1)
        
    }
    
    // Creates the view that the viewController manages
    override func loadView() {
        super.loadView()
        self.loadData()
        
        self.loadMajors()
        
        //Checks whether the user has logged in before, and if not, presents the information pop up
        let login = defaults.bool(forKey: "FirstLogin")
        if ((login == nil) || (login == false)){
            self.showInformationPopUp()
        }
        
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

    
    
    /// Sets specified image for button using url
    /// - Parameters:
    ///   - imageUrlString: url of image
    ///   - button: button that needs to be changed
    
    func urlToButtonImage(imageUrlString: String, button: UIButton){
        //gets the url
        let url = URL(string: imageUrlString)!
        
        //Pulls image data
        let task = URLSession.shared.dataTask(with: url){ data,response, error in
            guard let data = data, error == nil else {
                return}
            DispatchQueue.main.async {
                //sets the image data to the image view of the button
                button.setImage(UIImage(data:data), for: .normal)
            }
        }
        task.resume()    }
    
    
    
    /// Shows the information pop up when called
    func showInformationPopUp(){
        //sets popUp as the "InfoPop" view controller
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoPop") as! InfoPopUpViewController
        //Determines presentation style, this is basically a pop-up
        popUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //Presents the pop-up
        self.present(popUp, animated: true)
    }
    
    
    /// Displays the url as a Safari view controller
    ///
    /// - Parameter url: the url to be displayed.
    func show(_ url: String) {
        //gets the url
        if let url = URL(string: url) {
            //configures the safari view controller
            let config = SFSafariViewController.Configuration()
            //this immeditately registers it as reader view, determined this was best since they are looking at an article
            config.entersReaderIfAvailable = true
            //Sets the view controller based on the configurations made above
            let vc = SFSafariViewController(url: url, configuration: config)
            //Presents the view controller
            present(vc, animated: true)
        }
    }
    
    

    
 
    //-------------------------------------------------------------------------------
    // MARK: Salesforce related functions


    
    /// Loads salesforce data into store
    ///
    ///TO-DO: create different functions/methods for each query request
    func loadData(){
        
        //Creation of the loading indicator, this could be placed somewhere else in theory
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        //Configures the loadingIndicator
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0);
        loadingIndicator.center = homeView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        loadingIndicator.backgroundColor = #colorLiteral(red: 0.3971119523, green: 0.3989546299, blue: 0.4034414291, alpha: 0.7198469606)
        loadingIndicator.layer.cornerRadius = 10

        //Adds the loading indicator to the view, and then starts animating
        homeView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        //Pulls the user info (specifically the id and email)
        let userIdRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userIdRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            let jsonResponse = JSON(response!)
            let id = jsonResponse["user_id"].stringValue
            let email = jsonResponse["email"].stringValue
            let lastname = jsonResponse["family_name"].stringValue
            let firstname = jsonResponse["given_name"].stringValue
            DispatchQueue.main.async {
                self?.userId = id
                //Sets the "UserId" as Id in the default user storage
                self!.defaults.set(id,forKey: "UserId")
                self!.defaults.set(email,forKey: "Email")
                self!.defaults.set(firstname, forKey: "FirstName")
                self!.defaults.set(lastname, forKey: "LastName")
            }
            
            //Pulls the user info (specifically contactid).
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
                    let login = jsonContact["records"][0]["First_Login__c"
                    ].stringValue
                    print(jsonContact)

                    
                    DispatchQueue.main.async {
                        self!.defaults.set(login, forKey: "FirstLogin")
                        self!.defaults.set(state,forKey: "State")
                        self!.loadSchools()
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
        let schoolRequest = RestClient.shared.request(forQuery: "SELECT Name, Id, BillingState, BillingCity From Account WHERE BillingState = '\(self.defaults.string(forKey: "State")!)' OR Id = '001G000000t0ynOIAQ' ")
        RestClient.shared.send(request: schoolRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            if (((strongSelf.store.soupExists(forName: "School")))){
                strongSelf.store.clearSoup("School")
                strongSelf.store.upsert(entries: results, forSoupNamed: "School")
                os_log("\n\n----------------------SmartStore loaded records for school.-------------------------------", log: strongSelf.mylog, type: .debug)
                
            }
        }
    }
    


}//class
    
    
       

    

