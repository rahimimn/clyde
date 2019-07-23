//
//  ProfileViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//
//login.salesforce.com
import UIKit
import MobileCoreServices
import SalesforceSDKCore
import SmartSync
import SmartStore
import SwiftyJSON
import MapKit
import CoreLocation


/// Class for the Profile view
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate{
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private var userId = ""
    // Outlet for the menu button
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    // Outlet for distance between user and cofc
    @IBOutlet weak var distanceText: UILabel!
    
    // Outlet for user's profile picture image view
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Outlets for "Your Information"
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var birthdateText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var schoolText: UILabel!
    @IBOutlet weak var anticipatedStartText: UILabel!
    @IBOutlet weak var ethnicText: UILabel!
    @IBOutlet weak var genderText: UILabel!
    @IBOutlet weak var genderIdentityText: UILabel!
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var studentTypeText: UILabel!
    @IBOutlet weak var honorsCollegeInterestText: UILabel!
    @IBOutlet weak var mobileOptInText: UILabel!
    

    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    let mylog = OSLog(subsystem: "edu.cofc.club.clyde", category: "profile")

    
    
    // Private variables for map
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    // Outlet for map view
    @IBOutlet weak var profileMap: MKMapView!
    
    
    /// Function that updates the location constantly.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.currentLocation = locations.last as CLLocation?
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = #colorLiteral(red: 0.4470588235, green: 0.7803921569, blue: 0.9058823529, alpha: 1)
        return polylineRenderer
    }
    
    override func loadView() {
        super.loadView()
        self.createMap()
        self.placeInfo()
        let request = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: request, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user request: \(request)")
        }){ [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String,Any>,
               //error
                let result = jsonResponse["user_id"] as? [Dictionary<String,Any>]
                else {
                    return
            }
            SalesforceLogger.d(type(of:strongSelf),message:"Invoked: \(request)")
            if ((strongSelf.store.soupExists(forName: "User"))) {
                strongSelf.store.clearSoup("User")
                strongSelf.store.upsert(entries: result, forSoupNamed: "User")
                strongSelf.loadDataFromStore()
                os_log("\nSmartStore loaded records.", log: strongSelf.mylog, type: .debug)
            }
        }
        
        }
    
    func loadDataFromStore(){
        let querySpec = QuerySpec.buildSmartQuerySpec(

            smartSql: "select {user:Name}, {user:Id} from {user}",
            pageSize: 1)

        
        
        print(querySpec!)
    
        do {
            let records = try self.store.query(using: querySpec!, startingFromPageIndex: 0)
            print(records)
            guard let rows = records as? [[String]] else {
                print("we ARE LOOKING HERE!")
                print(records)
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)
                return
            }
            print(rows[0])
            DispatchQueue.main.async {
                
            }
        } catch let e as Error? {
            print(e as Any)
            print("Youre a failure dude")
            os_log("\n%{public}@", log: self.mylog, type: .debug, e!.localizedDescription)
        }
    
    
    
    
    
    }
 
   
    /// Loads the profile view
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.menuBar(menuBarItem: menuBarButton)
        }
    
    
    
    
     /// Pulls the Salesforce data and displays it on the page
     func placeInfo() {
        //-----------------------------------------------
        // USER INFORMATION
        addressText.delegate = self
        // Creates a request for user information, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (userAccountId)
        let userRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user request: \(userRequest)")
        }) { [weak self] (response, urlResponse) in
            let userAccountJSON = JSON(response!)
            let userAccountID = userAccountJSON["user_id"].stringValue
            let jsonResponse = JSON(response!)
            print(jsonResponse)
            //Creates a request for the user's contact id, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (contactAccountId)
            let contactIDRequest = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = '\(userAccountID)'")
            RestClient.shared.send(request: contactIDRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactIDRequest)")
            }) { [weak self] (response, urlResponse) in
                let contactAccountJSON = JSON(response!)
                let contactAccountID = contactAccountJSON["records"][0]["ContactId"].stringValue
                    let contactInformationRequest = RestClient.shared.request(forQuery: "SELECT MailingStreet, MailingCity, MailingPostalCode, MailingState, MobilePhone, Email, Name, Text_Message_Consent__c, Birthdate, TargetX_SRMb__Gender__c, Honors_College_Interest__c, TargetX_SRMb__Student_Type__c, Gender_Identity__c, Ethnicity_Non_Applicants__c,TargetX_SRMb__Graduation_Year__c FROM Contact WHERE Id = '\(contactAccountID)'")
                    RestClient.shared.send(request: contactInformationRequest, onFailure: { (error, urlResponse) in
                        SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactInformationRequest)")
                    }) { [weak self] (response, urlResponse) in
                        let contactInfoJSON = JSON(response!)
                        let contactGradYear = contactInfoJSON["records"][0]["TargetX_SRMb__Graduation_Year__c"].string
                        let contactEmail = contactInfoJSON["records"][0]["Email"].string
                        let contactEthnic = contactInfoJSON["records"][0][ "Ethnicity_Non_Applicants__c"].string
                        let contactStreet = contactInfoJSON["records"][0]["MailingStreet"].stringValue
                        let contactCode = contactInfoJSON["records"][0]["MailingPostalCode"].stringValue
                        let contactState = contactInfoJSON["records"][0]["MailingState"].stringValue
                        let contactCity = contactInfoJSON["records"][0]["MailingCity"].stringValue
                        let contactName = contactInfoJSON["records"][0]["Name"].stringValue
                        let contactBirth = contactInfoJSON["records"][0]["Birthdate"].stringValue
                        let cell = contactInfoJSON["records"][0]["MobilePhone"].stringValue
                        let gender = contactInfoJSON["records"][0]["TargetX_SRMb__Gender__c"].stringValue
                        let genderID = contactInfoJSON["records"][0]["TargetX_SRMb__Gender__c"].stringValue
                        let studentType = contactInfoJSON["records"][0]["TargetX_SRMb__Student_Type__c"].stringValue
                        let honorsCollegeInterest = contactInfoJSON["records"][0]["Honors_College_Interest__c"].stringValue
                        let mobileOptIn = contactInfoJSON["records"][0]["Text_Message_Consent__c"].string
                        
                        
                        
                        
                     
                            
                DispatchQueue.main.async {
                    self?.addressText.text = "\(contactStreet)\n\(contactCity), \(contactState), \(contactCode)"
                    self?.birthdateText.text = contactBirth
                    self?.emailText.text = contactEmail
                    self?.ethnicText.text = contactEthnic
                    self?.anticipatedStartText.text = contactGradYear
                    self?.userName.text = contactName
                    self?.userName.textColor = UIColor.black
                    self?.mobileText.text = cell
                    self?.genderText.text = gender
                    self?.genderIdentityText.text = genderID
                    self?.studentTypeText.text = studentType
                    if mobileOptIn == "false"{ self?.mobileOptInText.text = "Opt-out"}
                    else{ self?.mobileOptInText.text = "Opt-in"}
                    if honorsCollegeInterest == "false"{self?.honorsCollegeInterestText.text = "Yes"}
                    else{self?.honorsCollegeInterestText.text = "No"}
                    self?.userId = userAccountID
                }
                }}}
        
        //-------------------------------------------------
        // Sets the image style
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = 10
        
        
        
    }
    
    
    /// Function that adds the map to the view and calculates the distance between the user and college of charleston
    func createMap(){
        // MAP
        profileMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        profileMap.showsUserLocation = false
        profileMap.layoutMargins = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        
        
        guard let currentLocation = locationManager.location else{
            return
        }
        
        
        let cofcLocation = CLLocationCoordinate2D(latitude: 32.783830198, longitude: -79.936162922)
        let userLocation = CLLocationCoordinate2D(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude))
        
        let currentPlacemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil )
        let cofcPlacemark = MKPlacemark(coordinate: cofcLocation, addressDictionary: nil)
        
        let currentMapItem = MKMapItem(placemark: currentPlacemark)
        let cofcMapItem = MKMapItem(placemark: cofcPlacemark)
        
        let currentPointAnnotation = MKPointAnnotation()
        currentPointAnnotation.title = "You"
        currentPointAnnotation.subtitle = "This is your location."
        if let location = currentPlacemark.location {
            currentPointAnnotation.coordinate = location.coordinate
        }
        
        
        let cofcPointAnnotation = MKPointAnnotation()
        cofcPointAnnotation.title = "The College of Charleston!"
        
        if let location = cofcPlacemark.location {
            cofcPointAnnotation.coordinate = location.coordinate
        }
        self.profileMap.showAnnotations([currentPointAnnotation, cofcPointAnnotation], animated: true)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = currentMapItem
        directionsRequest.destination = cofcMapItem
        directionsRequest.transportType = .automobile
        
        let calculateDirections = MKDirections(request: directionsRequest)
        
        calculateDirections.calculate { [weak self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self?.profileMap.addOverlay(route.polyline)
                self?.profileMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        
        let cofcAddress = CLLocation(latitude: cofcLocation.latitude, longitude: cofcLocation.longitude)
        let distanceInMeters = currentLocation.distance(from:cofcAddress)
        
        self.distanceText.text = "\((distanceInMeters/1609.344).rounded().formatForProfile) miles"
        
        
        
        
        
    }
}


/// Class for the Edit Profile View
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, RestClientDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  // Variables
    
    //Picker options
    var birthSexOptions = ["Female","Male"]
    var genderOptions = ["Female","Male","Other"]
    var studentTypeOptions = ["Freshman","Transfer"]
    var ethnicOptions = ["Alaskan Native", "American Indian", "Asian", "Black or African American", "Hispanic", "Mexican or Mexican American", "Middle Eastern", "Native Hawaiian", "Other", "Pacific Islander", "Prefer to not respond", "Puerto Rican", "Two or more races", "White"]
    
    let genderPicker = UIPickerView()
    let genderIdentityPicker = UIPickerView()
    let studentTypePicker = UIPickerView()
    let ethnicPicker = UIPickerView()
    
    // Outlet for the menu button
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    // Outlet for user's profile photo image view
    @IBOutlet weak var profileImageView: UIImageView!
 
    
    // Outlets for the UI Textfields
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var highSchoolTextField: UITextField!
    @IBOutlet weak var graduationYearTextField: UITextField!
    @IBOutlet weak var ethnicOriginTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderIdentityTextField: UITextField!
    @IBOutlet weak var studentTypeTextField: UITextField!
    @IBOutlet weak var userName: UILabel!
    
    private var honorsCollegeInterestText = "false"
    @IBOutlet weak var honorsSwitch: UISwitch!
    @IBAction func honorsAction(_ sender: UISwitch) {
        if sender.isOn == true{
            honorsCollegeInterestText = "Hot Prospect"
        }else{
            honorsCollegeInterestText = "false"
        }
    }
    
    
    private var mobileOptInText = "false"
    @IBOutlet weak var mobileSwitch: UISwitch!
    @IBAction func mobileAction(_ sender: UISwitch) {
        if sender.isOn == true{
            mobileOptInText = "true"
        }else{
            mobileOptInText = "false"
        }
    }
    
    
    // Boolean variable to determine whether a new picture was added.
    var newPic: Bool?
    
    // Creates a UITapGestureRecognizer to edit the user's image
    let tapRec = UITapGestureRecognizer()
    
    // Creates a date picker for the birthday field.
    let datePicker = UIDatePicker()
   
    /// Function that shows the date picker for the birthdate field when called.
    private func showDatePicker(){
        // Formats the date picker.
        datePicker.datePickerMode = .date
        
        // Creates the toolbar and the sizes it to fit.
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        // Creates the various buttons.
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
    
        // Sets the buttons.
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        // Adds the datepicker and toolbar to the birthdate text field.
        birthDateTextField.inputAccessoryView = toolbar
        birthDateTextField.inputView = datePicker
    }
    
    // Determines when the user stops editing the date picker
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    
    /// Method that determines actions after "save" button pressed
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Call to push data into Salesforce
        upsertInformation()
        
        
    }
    
    /// UIPickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == genderIdentityPicker){
            return genderOptions.count
        }else if (pickerView == genderPicker){
            return birthSexOptions.count
        }else if (pickerView == ethnicPicker){
            return ethnicOptions.count
        }
        else{
          return studentTypeOptions.count
        }}
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == genderIdentityPicker){
            return genderOptions[row]
        } else if pickerView == genderPicker{
            return birthSexOptions[row]
        }else if pickerView == ethnicPicker{
            return ethnicOptions[row]
        }
        else{
            return studentTypeOptions[row]
        }
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.genderIdentityPicker{
            self.genderIdentityTextField.text = genderOptions[row]
        }else if pickerView == self.genderPicker{
        self.genderTextField.text = genderOptions[row]
        }else if pickerView == self.ethnicPicker{
            self.ethnicOriginTextField.text = ethnicOptions[row]
        }else{
            self.studentTypeTextField.text = studentTypeOptions[row]
        }
    }

    /// Presents view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushImage()
        // Sets the image style
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = 10
        
        // Adds tap gesture to the profileImageView
        tapRec.addTarget(self, action: #selector(tappedView))
        profileImageView.addGestureRecognizer(tapRec)
        
        // Delegates
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        birthDateTextField.delegate = self
        emailTextField.delegate = self
        highSchoolTextField.delegate = self
        graduationYearTextField.delegate = self
        ethnicOriginTextField.delegate = self
        mobileTextField.delegate = self
        genderIdentityTextField.delegate = self
        genderTextField.delegate = self
        studentTypeTextField.delegate = self
        
        // Calls showDatePicker
        showDatePicker()
        menuBar(menuBarItem: menuBarButton)
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        // Gender and Gender Identity pickers
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        genderTextField.inputAccessoryView = toolbar
        
        genderTextField.inputView = genderPicker
        genderPicker.delegate = self
        
        genderIdentityTextField.inputAccessoryView = toolbar
        genderIdentityTextField.inputView = genderIdentityPicker
        genderIdentityPicker.delegate = self
        
        
        studentTypeTextField.inputAccessoryView = toolbar
        studentTypeTextField.inputView = studentTypePicker
        studentTypePicker.delegate = self
        
        ethnicOriginTextField.inputAccessoryView = toolbar
        ethnicOriginTextField.inputView = ethnicPicker
        ethnicPicker.delegate = self
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        //-----------------------------------------------
        // USER INFORMATION
        addressTextField.delegate = self
        // Creates a request for user information, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (userAccountId)
        let userRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user request: \(userRequest)")
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
                let contactInformationRequest = RestClient.shared.request(forQuery: "SELECT MailingStreet, MailingCity, MailingPostalCode, MailingState, MobilePhone, Email, Name, Text_Message_Consent__c, Birthdate, TargetX_SRMb__Gender__c, Honors_College_Interest__c, TargetX_SRMb__Student_Type__c, Gender_Identity__c, Ethnicity_Non_Applicants__c,TargetX_SRMb__Graduation_Year__c FROM Contact WHERE Id = '\(contactAccountID)'")
                RestClient.shared.send(request: contactInformationRequest, onFailure: { (error, urlResponse) in
                    SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactInformationRequest)")
                }) { [weak self] (response, urlResponse) in
                    let contactInfoJSON = JSON(response!)
                    
                    let contactGradYear = contactInfoJSON["records"][0]["TargetX_SRMb__Graduation_Year__c"].string
                    let contactEmail = contactInfoJSON["records"][0]["Email"].string
                    let contactEthnic = contactInfoJSON["records"][0][ "Ethnicity_Non_Applicants__c"].string
                    let contactStreet = contactInfoJSON["records"][0]["MailingStreet"].stringValue
                    let contactCode = contactInfoJSON["records"][0]["MailingPostalCode"].stringValue
                    let contactState = contactInfoJSON["records"][0]["MailingState"].stringValue
                    let contactCity = contactInfoJSON["records"][0]["MailingCity"].stringValue
                    let contactName = contactInfoJSON["records"][0]["Name"].stringValue
                    let contactBirth = contactInfoJSON["records"][0]["Birthdate"].stringValue
                    let cell = contactInfoJSON["records"][0]["MobilePhone"].stringValue
                    let gender = contactInfoJSON["records"][0]["TargetX_SRMb__Gender__c"].stringValue
                    let genderID = contactInfoJSON["records"][0]["TargetX_SRMb__Gender__c"].stringValue
                    let studentType = contactInfoJSON["records"][0]["TargetX_SRMb__Student_Type__c"].stringValue
                    let honorsCollegeInterest = contactInfoJSON["records"][0]["Honors_College_Interest__c"].stringValue
                    let mobileOptIn = contactInfoJSON["records"][0]["Text_Message_Consent__c"].string
                    
                    DispatchQueue.main.async {
                        self?.addressTextField.text = contactStreet
                        self?.cityTextField.text = contactCity
                        self?.stateTextField.text = contactState
                        self?.zipTextField.text = contactCode
                        self?.birthDateTextField.text = contactBirth
                        self?.emailTextField.text = contactEmail
                        self?.ethnicOriginTextField.text = contactEthnic
                        self?.graduationYearTextField.text = contactGradYear
                        self?.userName.text = contactName
                        self?.userName.textColor = UIColor.black
                        self?.mobileTextField.text = cell
                        self?.genderTextField.text = gender
                        self?.genderIdentityTextField.text = genderID
                        self?.studentTypeTextField.text = studentType
                        if mobileOptIn == "false"{ self?.mobileOptInText = "false"
                            self?.mobileSwitch.setOn(false, animated: true)
                        }
                        else{ self?.mobileOptInText = "true"
                            self?.mobileSwitch.setOn(true, animated: true)
                        }
                        if honorsCollegeInterest == "Hot Prospect"{self?.honorsCollegeInterestText = "Hot Prospect"
                            self?.honorsSwitch.setOn(true, animated: true)
                        }
                        else{self?.honorsCollegeInterestText = "false"
                            self?.honorsSwitch.setOn(false, animated: true)
                        }
                    }
                }}}}
    
    
    
    
    /// Fucntion that sends data into Salesforce, this will need to be edited at some point
    private func upsertInformation(){
        
        // Creates a new record and stores appropriate fields.
        var record = [String: Any]()
        record["MailingStreet"] = self.addressTextField.text
        record["MailingCity"] = self.cityTextField.text
        record["MailingState"] = self.stateTextField.text
        record["MailingPostalCode"] = self.zipTextField.text
        record["TargetX_SRMb__Graduation_Year__c"] = self.graduationYearTextField.text
        record["Ethnicity_Non_Applicants__c"] = self.ethnicOriginTextField.text
        record["Email"] = self.emailTextField.text
        //record["AccountId"] = "001S00000105zkuIAA"
        record["Birthdate"] = self.birthDateTextField.text
        record["MobilePhone"] = self.mobileTextField.text
        record["TargetX_SRMb__Gender__c"] = self.genderTextField.text
        record["Gender_Identity__c"] = self.genderIdentityTextField.text
        record["TargetX_SRMb__Student_Type__c"] = self.studentTypeTextField.text
        record["Honors_College_Interest__c"] = self.honorsCollegeInterestText
        record["Text_Message_Consent__c"] = self.mobileOptInText
        
        // NEED TO FIGURE OUT A WAY TO CONNECT THIS TO A USER NSOBJECT.
        // Creates a request for user information, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (userAccountId)
        let userRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user request: \(userRequest)")
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
               
        print("Creating upsert request")
        //Creates the upsert request.
        let upsertRequest = RestClient.shared.requestForUpsert(withObjectType: "Contact", externalIdField: "Id", externalId: contactAccountID, fields: record)
        
        
        
        
        //Sends the upsert request
        RestClient.shared.send(request: upsertRequest, onFailure: { (error, URLResponse) in
            SalesforceLogger.d(type(of:self!), message:"Error invoking while sending upsert request: \(upsertRequest), error: \(error)")
            //Creates a save alert to be presented whenever the user saves their information
            let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self?.present(errorAlert, animated: true)
        }){(response, URLResponse) in
            //Creates a save alert to be presented whenever the user saves their information
            let saveAlert = UIAlertController(title: "Information Saved", message: "Your information has been saved.", preferredStyle: .alert)
            saveAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self?.present(saveAlert, animated: true)
            os_log("\nSuccessful response received")
        }
    }
        }
    }
    
    private func pushImage(){
        let userRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking on user request: \(userRequest)")
        }) { [weak self] (response, urlResponse) in
            let userAccountJSON = JSON(response!)
            let userAccountID = userAccountJSON["picture"].stringValue
            print(userAccountJSON)
            print(userAccountID)
        }
        
    }
    
    
    
    
    /// Method that returns a textfield's input
    ///
    /// - Parameter textfield: The textfield that will return.
    /// - Returns: Boolean on whether a textfield should return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.textColor = UIColor.black
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    /// Method that creates the camera and photo library action
    @objc func tappedView(){
        let alert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    
    /// Method that creates the image picker controller.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            profileImageView.image = image
            
            if newPic == true{
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Error handler for the image picker
    @objc func imageError(image: UIImage, didFinishSavingwithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if error != nil{
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

}
