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
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var state: UIPickerView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    var newPic: Bool?
    
    var stateData: [String] = [String]()
    var selectedState = ""
    //TO-DO: Create functions that allow the "edit" button to be tapped, and THEN allow for profile editing.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.state.delegate = self
        self.state.dataSource = self
        stateData = [ "AK - Alaska",
                       "AL - Alabama",
                       "AR - Arkansas",
                       "AS - American Samoa",
                       "AZ - Arizona",
                       "CA - California",
                       "CO - Colorado",
                       "CT - Connecticut",
                       "DC - District of Columbia",
                       "DE - Delaware",
                       "FL - Florida",
                       "GA - Georgia",
                       "GU - Guam",
                       "HI - Hawaii",
                       "IA - Iowa",
                       "ID - Idaho",
                       "IL - Illinois",
                       "IN - Indiana",
                       "KS - Kansas",
                       "KY - Kentucky",
                       "LA - Louisiana",
                       "MA - Massachusetts",
                       "MD - Maryland",
                       "ME - Maine",
                       "MI - Michigan",
                       "MN - Minnesota",
                       "MO - Missouri",
                       "MS - Mississippi",
                       "MT - Montana",
                       "NC - North Carolina",
                       "ND - North Dakota",
                       "NE - Nebraska",
                       "NH - New Hampshire",
                       "NJ - New Jersey",
                       "NM - New Mexico",
                       "NV - Nevada",
                       "NY - New York",
                       "OH - Ohio",
                       "OK - Oklahoma",
                       "OR - Oregon",
                       "PA - Pennsylvania",
                       "PR - Puerto Rico",
                       "RI - Rhode Island",
                       "SC - South Carolina",
                       "SD - South Dakota",
                       "TN - Tennessee",
                       "TX - Texas",
                       "UT - Utah",
                       "VA - Virginia",
                       "VI - Virgin Islands",
                       "VT - Vermont",
                       "WA - Washington",
                       "WI - Wisconsin",
                       "WV - West Virginia",
                       "WY - Wyoming"]
        
        
        
        
        
        //Sets the image style
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = 10
        
        //allows image to be tapped
        tapRec.addTarget(self, action: #selector(tappedView))
        profileImageView.addGestureRecognizer(tapRec)
        
        //menu reveal
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = stateData[row]
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
