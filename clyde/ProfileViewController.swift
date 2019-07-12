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
import SwiftyJSON
import MapKit
import CoreLocation


/// Class for the Profile view
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate{
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    @IBOutlet weak var graduationText: UILabel!
    @IBOutlet weak var ethnicText: UILabel!
    
    

    
    
    
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
    
    

    
    /// Loads the profile view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMap()
        self.menuBar(menuBarItem: menuBarButton)
        }
    
    override func viewWillAppear(_ animated: Bool) {

      
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
            
            
            //Creates a request for the user's contact id, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (contactAccountId)
            let contactIDRequest = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = '\(userAccountID)'")
            RestClient.shared.send(request: contactIDRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactIDRequest)")
            }) { [weak self] (response, urlResponse) in
                let contactAccountJSON = JSON(response!)
                let contactAccountID = contactAccountJSON["records"][0]["ContactId"].stringValue
                    let contactInformationRequest = RestClient.shared.request(forQuery: "SELECT MailingStreet,MailingCity,MailingPostalCode,MailingState,Email,Name, Birthdate,TargetX_SRMb__Graduation_Year__c,TargetX_SRMb__IPEDS_Ethnicities__c FROM Contact WHERE Id = '\(contactAccountID)'")
                    RestClient.shared.send(request: contactInformationRequest, onFailure: { (error, urlResponse) in
                        SalesforceLogger.d(type(of:self!), message:"Error invoking on contact id request: \(contactInformationRequest)")
                    }) { [weak self] (response, urlResponse) in
                        let contactInfoJSON = JSON(response!)
                        
                        let contactGradYear = contactInfoJSON["records"][0]["TargetX_SRMb__Graduation_Year__c"].string
                        let contactEmail = contactInfoJSON["records"][0]["Email"].string
                        let contactEthnic = contactInfoJSON["records"][0][ "TargetX_SRMb__IPEDS_Ethnicities__c"].string
                        let contactStreet = contactInfoJSON["records"][0]["MailingStreet"].stringValue
                        let contactCode = contactInfoJSON["records"][0]["MailingPostalCode"].stringValue
                        let contactState = contactInfoJSON["records"][0]["MailingState"].stringValue
                        let contactCity = contactInfoJSON["records"][0]["MailingCity"].stringValue
                        let contactName = contactInfoJSON["records"][0]["Name"].stringValue
                        let contactBirth = contactInfoJSON["records"][0]["Birthdate"].stringValue
                
                
                
                DispatchQueue.main.async {
                    self?.addressText.text = "\(contactStreet)\n\(contactCity), \(contactState), \(contactCode)"
                    self?.birthdateText.text = contactBirth
                    self?.emailText.text = contactEmail
                    self?.ethnicText.text = contactEthnic
                    self?.graduationText.text = contactGradYear
                    self?.userName.text = contactName
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
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, RestClientDelegate{
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  // Variables
    
    
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
    
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
    
    /// Ends editing of the date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    /// Method that determines actions after "save" button pressed
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Call to push data into Salesforce
        upsertInformation()
        
        //Creates a save alert to be presented whenever the user saves their information
        let saveAlert = UIAlertController(title: "Information Saved", message: "Your information has been saved.", preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(saveAlert, animated: true)
    }
    
    
   
    
    /// Presents view
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        // Calls showDatePicker
        showDatePicker()
        menuBar(menuBarItem: menuBarButton)
    
    }
    
    /// Fucntion that sends data into Salesforce, this will need to be edited at some point
    private func upsertInformation(){
        
        // Creates a new record and stores appropriate fields.
        var record = [String: Any]()
        record["MailingStreet"] = self.addressTextField.text
        record["MailingCity"] = self.cityTextField.text
        record["MailingState"] = self.stateTextField.text
        record["MailingPostalCode"] = self.zipTextField.text
        record["TargetX_SRMb__Graduation_Year__c"] = self.graduationYearTextField.text
        //record["TargetX_SRMb__IPEDS_Ethnicities__c"] = self.ethnicOriginTextField.text
        record["Email"] = self.emailTextField.text
       // record["AccountId"] = "001S00000105zkuIAA"
        
        print(record)
        
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
        }){(response, URLResponse) in
            os_log("\nSuccessful response received")
        }
    }
        }
    }
    
    
    
    
    
    
    /// Method that returns a textfield's input
    ///
    /// - Parameter textfield: The textfield that will return.
    /// - Returns: Boolean on whether a textfield should return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
