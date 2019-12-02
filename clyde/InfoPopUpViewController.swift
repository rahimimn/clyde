//
//  InfoPopUpViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 8/5/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SmartSync
import SearchTextField

/// Class for the Info Pop Up
class InfoPopUpViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    
    
    //----------------------------------------------------------
    // MARK: Outlets
    @IBOutlet weak var answer: SearchTextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var header: UILabel!
    
    
    //-----------------------------------------------------------
    // MARK: Variables
    
    //Creates the store variable
    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)
    let mylog = OSLog(subsystem: "edu.cofc.clyde", category: "infoPopUp")
    
    var counter = 0
    
    let defaults = UserDefaults.standard
    
    var questions = ["Your mobile number:", "Do you want to opt-in for mobile messaging?", "Your major interest?","Your street address:","Your city:","Your state", "Your zip code:","Your gender:", "Are you interested in the Honors College?","Your student type:",""]
    
  
    var possibleAnswers = [[],["Yes", "No"],["Accounting", "African American Studies","Anthropolgy","Archaeology","Art History","Arts Management","Astronomy","Astrophysics","Bachelor of General StudieS","Bachelor of Professional Studies","Biochemisty","Biology","Biomedical Physics","Business Administration","Chemistry","Classics","Commercial Real Estate Finance","Communication","Computer Information Systems","Computer Science","Computing in the Arts","Dance","Data Science","Early Childhood Education","Economics","Elementary Education","Engineering, Systems","English","Exercise Science","Finance","Foreign Language Education","French","General Studies", "Geology","German","Historic Preservation and Community Planning","History","Hospitatlity and Toursim Management","International Business","International Studies","Jewish Studies","Latin American and Caribbean Studies","Marine Biology","Marketing","Mathematics","Meteorology","Middle Grades Education","Music","Philosophy","Physical Education","Physics","Political Science","Psychology","Public Health", "Religious Studies","Secondary Education", "Studio Art", "Spanish", "Sociology", "Supply Chain Management","Theatre","Urban Studies","Women's and Gender Studies"],[],[],[],[],["Female", "Male", "Other"],["Yes","No"],["Freshman","Transfer"],[]]
    
    var answers = [] as Array


    //------------------------------------------------------------------
    // MARK: View functions
    
    //Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        answer.delegate = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        answer.delegate = self
        answer.inputAccessoryView = toolbar
        
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        answer.startVisibleWithoutInteraction = false
        answer.borderStyle = UITextField.BorderStyle.roundedRect
        self.answers.append(answer.text!)
        print(answers)
        question.text = questions[counter]
        answer.filterStrings(possibleAnswers[counter])
        header.text = "Clyde wants to know..."
        counter += 1
        if (counter + 1) == questions.count{
            sender.setTitle("Finish", for: [])
        }
        if (counter == questions.count){
            self.dismiss(animated: true, completion: nil)
            insertIntoSoup()
            updateToSalesforce()
            print(answers)
            defaults.set(false, forKey: "FirstLogin")
        }
        answer.text = ""
    }
    
    
    //----------------------------------------------------------------
    //MARK: Textfield functions
    
    
    /// Method that returns a textfield's input
    ///
    /// - Parameter textfield: The textfield that will return.
    /// - Returns: Boolean on whether a textfield should return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.textColor = UIColor.black
        return true
    }
    
    /// Method that is called when the textfield ends editing
    ///
    /// - Parameter textField: the textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black    }
    
    /// Method that is called when the textfield begins editing
    ///
    /// - Parameter textField: the textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        
    }
    
    
    
    //-----------------------------------------------------------------
    // MARK: Salesforce functions
    
    /// Pushes answers to salesforce
    private func updateToSalesforce(){
        var record = [String: Any]()
        record["MobilePhone"] = answers[1]
        record["Text_Message_Consent__c"] = answers[2]
        record["TargetX_SRMb__Anticipated_Major__c"] = answers[3]
        record["MailingStreet"] = answers[4]
        record["MailingCity"] = answers[5]
        record["MailingPostalCode"] = answers[6]
        record["MailingState"] = answers[7]
        record["TargetX_SRMb__Gender__c"] = answers[8]
        record["Honors_College_Interest_Check__c"] = answers[9]
        record["Status_Category__c"] = answers[10]
        
        if answers[2] as! String == "Yes"{
            record["Text_Message_Consent__c"] = "true"
        }else{
            record["Text_Message_Consent__c"] = "false"
            
        }
        if answers[9] as! String == "Yes"{
            record["Honors_College_Interest_Check__c"] = "false"
        }else{
            record["Honors_College_Interest_Check__c"] = "true"
            
        }
        
        print(record)
        
        
        let contactAccountID = defaults.string(forKey: "ContactId")
        //Creates the update request.
        let updateRequest = RestClient.shared.requestForUpdate(withObjectType: "Contact", objectId: contactAccountID!, fields: record)
        
        //Sends the update request
        RestClient.shared.send(request: updateRequest, onFailure: { (error, URLResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking while sending update request: \(updateRequest), error: \(String(describing: error))")
            //Creates a save alert to be presented whenever the user saves their information
            let errorAlert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(errorAlert, animated: true)
        }){(response, URLResponse) in
            //Creates a save alert to be presented whenever the user saves their information
            let saveAlert = UIAlertController(title: "Information Saved", message: "Your information has been saved.", preferredStyle: .alert)
            saveAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(saveAlert, animated: true)
            os_log("\nSuccessful response received")}
        
        
    }
   
    
    /// Pulls data from the user form and upserts it into the "Contact" soup
    func insertIntoSoup(){
        
        let JSONData : [String:Any] = ["MobilePhone": answers[1],
                                       "Text_Message_Consent__c": answers[2],
                                       "TargetX_SRMb__Anticipated_Major__c": answers[3],
                                       "MailingStreet": answers[4],
                                       "MailingCity": answers[5],
                                       "MailingState": answers[6],
                                       "MailingPostalCode": answers[7],
                                       "TargetX_SRMb__Gender__c": answers[8],
                                       "Honors_College_Interest_Check_c": answers[9],
                                       "Status_Category__c": answers[10],
                                       "First_Login__c": 1,
                                       "__locally_deleted__": false,
                                       "__locally_updated__": true,
                                       "__locally_created__": false,
                                       "__local__": true,]
        print(JSONData)
       if (((self.store?.soupExists(forName: "Contact"))!)){
           // self.store?.clearSoup("Contact")
            self.store?.upsert(entries: [JSONData], forSoupNamed: "Contact")
           os_log("\n\nSmartStore loaded records for contact.", log: self.mylog, type: .debug)
       }
    }
    
    func syncUp(){
        if let smartStore = self.store,
            let  syncMgr = SyncManager.sharedInstance(store: smartStore) {
            do {
                try syncMgr.reSync(named: "syncUpContact") { [weak self] syncState in
                    if syncState.isDone() {
                        let alert = UIAlertController(title: "Information Saved", message: "Clyde Club saved your information.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        
                        self?.present(alert, animated: true)
                        
                    }
                }
            } catch {
                print("Unexpected sync error: \(error).")
            }
        }     }
    

   
}
