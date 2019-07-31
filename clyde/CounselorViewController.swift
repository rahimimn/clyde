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
import SmartSync
import MessageUI


/// Pulls the user's admission counselor from Salesforce and then presents the data on the view controller.
class CounselorViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //Variable names
    var name: String = ""
    var about: String = ""
    var email: String = ""
    var id: String = ""
    var studentID: String = ""
    
    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)
    let mylog = OSLog(subsystem: "edu.cofc.club.clyde", category: "profile")
    
   //Outlets for the view controller
    @IBOutlet var counselorView: UIView!
    @IBOutlet weak var counselorImage: UIImageView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var counselorEmail: UIButton!
    @IBOutlet weak var phoneText: UIButton!
    
    
    /// When button is pressed, will take in the counselor's phone number, remove the - and (), and then calls the number.
    /// This will not work in the simulator.
    /// - Parameter sender: action button
    @IBAction func phone(_ sender: UIButton) {
        if  let phone = phoneText.titleLabel?.text{
            if let url = URL(string: "tel://\(phone.digitsOnly())"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            } else {
                print("This is not a valid number.")
            }
        }
    }
    
    
    /// When button is tapped, will email the counselor.
    ///This will not work in the simulator.
    /// - Parameter sender: action button
    @IBAction func email(_ sender: UIButton) {
        if let email = counselorEmail.titleLabel?.text{
            //Email "settings", these can be changed to anything.
            let subject = "Question Sent From Clyde Club"
            let body = "Hi!"
            let to = [email]
            //Creates the mail view, allows user to write an email to the counselor.
            let mailView: MFMailComposeViewController = MFMailComposeViewController()
            mailView.mailComposeDelegate = self
            mailView.setSubject(subject)
            mailView.setMessageBody(body, isHTML: false)
            mailView.setToRecipients(to)
            
            self.present(mailView, animated: true, completion: nil)

        }
        
    }
    

    /// Will present a view controller with the Office of Admissions
    /// Instagram Page after the button is tapped.
    ///
    /// - Parameter sender: action button
    @IBAction func instagram(_ sender: UIButton) {
        show("https://www.instagram.com/cofcadmissions/")    }
    
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.pullInformation()
       // self.hardCode()
        self.loadDataFromStore()
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
       
        
        
    }
   
    /// Tells the delegate that the user wants to close the mail composition
    /// view.
    ///
    /// - Parameters:
    ///   - controller: The view controller that manages the mail composition view.
    ///   - result: The result of the user’s action.
    ///   - error: Contains an error, if an error occurs.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func loadDataFromStore(){
        // Loading Indicator is created, starts animated before user's information request is sent
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        loadingIndicator.center = counselorView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = #colorLiteral(red: 0.6127323508, green: 0.229350239, blue: 0.2821176946, alpha: 1)
        counselorView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        let querySpec = QuerySpec.buildSmartQuerySpec(smartSql: "select {Counselor:Name}, {Counselor:Phone}, {Counselor:AboutMe},{Counselor:Email}, {Counselor:Image_Url__c} from {Counselor}", pageSize: 1)
        
        do{
            let records = try self.store?.query(using: querySpec!, startingFromPageIndex: 0)
            guard let record = records as? [[String]] else{
                print(records)
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)
                return
            }
            
            print(record)
        }catch let e as Error?{
            print(e as Any)
        }
    }
    
    
    
    func hardCode(){
        self.aboutMeText.text = "Hannah is a New Jersey native and recent graduate from the College. She's excited to hit the road and find the newest class of Cougars! (Hannah's the best. We know you'll love her, too!)"
        self.aboutLabel.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
        self.contactLabel.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
        self.name = "Hannah Fralinger"
        self.counselorName.text = "Hannah Fralinger"
        self.counselorEmail.setTitle("Email: \("fralingerhe@cofc.edu")", for: .normal)
        self.phoneText.setTitle("Phone: \("6095014811")", for: .normal)
        self.contactLabel.text = "Contact Information"
        self.aboutLabel.text = "About"
        self.header.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
        self.instagramButton.setTitle("@cofcadmissions", for: .normal)
        self.instagramButton.backgroundColor = #colorLiteral(red: 0.558098033, green: 0.1014547695, blue: 0.1667655639, alpha: 0.6402504281)
        
        
        let url = URL(string: "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000dxMH&oid=00D540000001Vbx&lastMod=1564580991000")!
        
        let task = URLSession.shared.dataTask(with: url){ data,response, error in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                self.counselorImage.image = UIImage(data:data)
                
            }
        }
        task.resume()
    }
    
    
    
    
    
    /// Pulls counselor infomation from Salesforce and then presents it.
    /// Information pulled: Image, Name, About, Email, Phone
    func pullInformation(){
        
        // Loading Indicator is created, starts animated before user's information request is sent
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        loadingIndicator.center = counselorView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = #colorLiteral(red: 0.6127323508, green: 0.229350239, blue: 0.2821176946, alpha: 1)
        counselorView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        let alert = UIAlertController(title: "Counselor Not Available", message: "There was an error involving the database.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true)
//        let idquerySpec = QuerySpec.buildSmartQuerySpec(smartSql: "select {User:Id} from {User}", pageSize: 1)
//        do{
//            let records = try self.store.query(using: idquerySpec!, startingFromPageIndex: 0)
//            guard let
//        }
//
//
        //Gets the user's information from Salesforce using the user's id.
       let userRequest = RestClient.shared.requestForUserInfo()
       RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user info request: \(userRequest)")
            loadingIndicator.stopAnimating()
            self.present(alert, animated:true)
        
       }) { [weak self] (response, urlResponse) in
        let userAccountJSON = JSON(response!);           let userAccountID = userAccountJSON["user_id"].stringValue
        
            
        
        
        //Creates a request for the user's contact id, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (contactAccountId)
            let contactIDRequest = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = '\(userAccountID)'")
            RestClient.shared.send(request: contactIDRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactIDRequest)")
                loadingIndicator.stopAnimating()
                self!.present(alert, animated:true)
            }) { [weak self] (response, urlResponse) in
                let contactAccountJSON = JSON(response!)
                let contactAccountID = contactAccountJSON["records"][0]["ContactId"].stringValue
                
                
                // Creates a request for the user's counselor id, sends it, and saves json into response, uses SWIFTYJSON to convert needed data
                let counselorIDRequest = RestClient.shared.request(forQuery: "SELECT OwnerId FROM Contact WHERE Id = '\(contactAccountID)'")
                RestClient.shared.send(request: counselorIDRequest, onFailure: { (error, urlResponse) in
                    print(error!)
                    loadingIndicator.stopAnimating()
                    self!.present(alert, animated:true)
                    SalesforceLogger.d(type(of:self!), message:"Error invoking on counselor ID Request: \(counselorIDRequest)")
                    
                }) { [weak self] (response, urlResponse) in
                    let counselorAccountJSON = JSON(response!)
                    let counselorId = counselorAccountJSON["records"][0]["OwnerId"]
                    
                    
                    //Creates a request for counselor info, and saves json into response, uses SWIFTYJSON to convert needed data
                    let counselorInfoRequest = RestClient.shared.request(forQuery: "SELECT AboutMe,Email,Name,Phone,Image_Url__c FROM User WHERE Id = '\(counselorId)'")
                    
                    RestClient.shared.send(request: counselorInfoRequest, onFailure: { (error, urlResponse) in
                        loadingIndicator.stopAnimating()
                        self!.present(alert, animated:true)
                        SalesforceLogger.d(type(of:self!), message:"Error invoking on counselor info Request: \(counselorInfoRequest)")
                        
                    }) { [weak self] (response, urlResponse) in
                        let counselorInfoJSON = JSON(response!)
                        let counselorName = counselorInfoJSON["records"][0]["Name"].stringValue
                        let counselorAbout = counselorInfoJSON["records"][0]["AboutMe"].stringValue
                        let counselorEmail = counselorInfoJSON["records"][0]["Email"].stringValue
                        let counselorPhone = counselorInfoJSON["records"][0]["Phone"].stringValue
                        let counselorImageUrl = counselorInfoJSON["records"][0]["Image_Url__c"].stringValue
                
                DispatchQueue.main.async {
                   
                    self!.aboutMeText.text = counselorAbout
                    self!.aboutLabel.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
                    self!.contactLabel.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
                    self!.name = counselorName
                    self!.counselorName.text = counselorName
                    self!.counselorEmail.setTitle("Email: \(counselorEmail)", for: .normal)
                    self!.phoneText.setTitle("Phone: \(counselorPhone)", for: .normal)
                    self!.contactLabel.text = "Contact Information"
                    self!.aboutLabel.text = "About"
                    self!.header.backgroundColor = #colorLiteral(red: 0.8870992064, green: 0.8414486051, blue: 0.7297345996, alpha: 1)
                self!.instagramButton.setTitle("@cofcadmissions", for: .normal)
                    self!.instagramButton.backgroundColor = #colorLiteral(red: 0.558098033, green: 0.1014547695, blue: 0.1667655639, alpha: 0.6402504281)
                    loadingIndicator.stopAnimating()
                    
                }//dispatch
                    }//counselor info
                }//counselor id
        }//contact
    }//user
    }
            

    /// Displays the URL within Safari
    ///
    /// - Parameter url: the url to be displayed
    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }




}
