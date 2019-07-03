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



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
   
    
    @IBOutlet weak var userName: UILabel!
    
    

    //TO-DO: Create functions that allow the "edit" button to be tapped, and THEN allow for profile editing.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the image style
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = 10
        
        
        //menu reveal
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    

    
    
}


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, RestClientDelegate{
    
    
    
    
  //Variables
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var highSchoolTextField: UITextField!
    @IBOutlet weak var graduationYearTextField: UITextField!
    @IBOutlet weak var ethnicOriginTextField: UITextField!
    
    var newPic: Bool?
    let tapRec = UITapGestureRecognizer()
    
    //birthday
    let datePicker = UIDatePicker()
    //Creates a date picker object for the birthday field
   
    private func showDatePicker(){
        //formats date
        datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        birthDateTextField.inputAccessoryView = toolbar
        birthDateTextField.inputView = datePicker
        
    }
    
    //Determines when the user stops editing the date picker
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //Ends editing of the date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    //Method that determines actions after "save" button pressed
    @IBAction func saveButtonPressed(_ sender: UIButton) {
         upsertInformation()
        let saveAlert = UIAlertController(title: "Information Saved", message: "Your information has been saved.", preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(saveAlert, animated: true)
        
       
    }
    
    

 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the image style
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = 10
        
        
        tapRec.addTarget(self, action: #selector(tappedView))
        profileImageView.addGestureRecognizer(tapRec)
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        birthDateTextField.delegate = self
        emailTextField.delegate = self
        highSchoolTextField.delegate = self
        graduationYearTextField.delegate = self
        ethnicOriginTextField.delegate = self
        showDatePicker()
        
        
        //menu reveal
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        

    }
    
    //Upserts information into Salesforce
    private func upsertInformation(){
        
        
        
       
        
        
        //Creates a new record and stores appropriate fields.
        var record = [String: Any]()
        record["MailingStreet"] = self.addressTextField.text
        record["MailingCity"] = self.cityTextField.text
        record["MailingState"] = self.stateTextField.text
        record["MailingPostalCode"] = self.zipTextField.text
        record["TargetX_SRMb__Graduation_Year__c"] = self.graduationYearTextField.text
        record["TargetX_SRMb__Ethnicity__c"] = self.ethnicOriginTextField.text
        record["Email"] = self.emailTextField.text
        record["School_Company_name__c"] = self.highSchoolTextField.text
        
        print(record)
        
        // NEED TO FIGURE OUT A WAY TO CONNECT THIS TO A USER NSOBJECT.
        //Creates a request for user information, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (userAccountId)
        let userRequest = RestClient.shared.requestForUserInfo()
        RestClient.shared.send(request: userRequest, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking: \(userRequest)")
        }) { [weak self] (response, urlResponse) in
            let userAccountJSON = JSON(response!)
            let userAccountID = userAccountJSON["user_id"].stringValue
            
            
            //Creates a request for the user's contact id, sends it, saves the json into response, uses SWIFTYJSON to convert needed data (contactAccountId)
            let contactIDRequest = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = '\(userAccountID)'")
            RestClient.shared.send(request: contactIDRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self!), message:"Error invoking: \(userRequest)")
            }) { [weak self] (response, urlResponse) in
                let contactAccountJSON = JSON(response!)
                let contactAccountID = contactAccountJSON["records"][0]["ContactId"].stringValue
               
            
            
      
        
        //Creates the upsert request.
        let upsertRequest = RestClient.shared.requestForUpsert(withObjectType: "Contact", externalIdField: "Id", externalId: contactAccountID, fields: record)
        
        
        
        
        //Sends the upsert request
        RestClient.shared.send(request: upsertRequest, onFailure: { (error, URLResponse) in
             SalesforceLogger.d(type(of:self!), message:"Error invoking: \(upsertRequest)")
        }){(response, URLResponse) in
            os_log("\nSuccessful response received")
        }
    }
        }
    }
    
    
    
    
    
    
    //Returns textfield's value
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //function that creates the camera and photo library action
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
    
    
    //function that creates the image picker controller
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
    
    // error handler
    @objc func imageError(image: UIImage, didFinishSavingwithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if error != nil{
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
