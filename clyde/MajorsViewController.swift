//
//  MajorsViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SmartStore
import SmartSync

// TO-DO: functions that allow the user to determine whether they like the major or not, and depending on input, perform some action
//  like: add to list of majors the student is interested in and remove from array/dictionary
//  maybe: add to list of majors the student is interested in and remove from array
//  dislike: remove from array

class MajorsViewController: UIViewController {

    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    let mylog = OSLog(subsystem: "edu.cofc.clyde", category: "Majors")
    var majorCounter: Int = 0
    var contactId = ""
    var interestName = ""
    var websiteUrl = ""
    var interestId = ""
    var preference = ""
    var selectedId =  ""
    @IBOutlet weak var majorImage: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorDescription: UITextView!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        self.majorLabel.adjustsFontSizeToFitWidth = true
        self.majorDescription.adjustsFontForContentSizeCategory = true
    }
    
    override func loadView() {
        super.loadView()
        self.loadFromStore()
        self.getContactId()

    }
    

    func loadFromStore(){
        let querySpec = QuerySpec.buildSmartQuerySpec(smartSql: "select {Major:Name},{Major:Website__c},{Major:Description__c},{Major:Image_Url__c}, {Major:Id} from {Major}", pageSize: 60)
        do{
            let records = try self.store.query(using: querySpec!, startingFromPageIndex: 0)
            guard let record = records as? [[String]] else{
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)

                return
            }
            if majorCounter == record.count{
                majorCounter = 0
            }
            
            let name = record[self.majorCounter][0]
            let website = record[self.majorCounter][1]
            let description = record[self.majorCounter][2]
            let image = record[self.majorCounter][3]
            let id = record[self.majorCounter][4]
            
            
            DispatchQueue.main.async {
                
                let url = URL(string: image)!
                let task = URLSession.shared.dataTask(with: url){ data,response, error in
                    guard let data = data, error == nil else {return}
                    DispatchQueue.main.async {
                        self.majorImage.image = UIImage(data:data)
                        self.majorCounter = self.majorCounter + 1
                        self.majorLabel.text = name
                        self.majorDescription.text = description
                        self.websiteUrl = website
                        self.interestName = name
                        self.interestId = id

                    }
                }
                task.resume()
            }
        }catch let e as Error?{
            print(e as Any)
        }
        
    }
    
    func getContactId(){
        let userQuery = QuerySpec.buildSmartQuerySpec(smartSql: "select {Contact:Id} from {Contact}", pageSize: 1)
        do{
            let records = try self.store.query(using: userQuery!, startingFromPageIndex: 0)
            guard let record = records as? [[String]] else{
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)
                print(records)
                return
            }
            
            let id = record[self.majorCounter][0]
            print("This is the contactId within the request \(id)")
            
            DispatchQueue.main.async {
                
                
                    DispatchQueue.main.async {
                        self.contactId = id
                        
                    }
                }
            
        }catch let e as Error?{
            print(e as Any)
        }
    }
    
    
    func pushUsingSalesforce(_ button: Int){
        var record = [String : Any]()
        if button == 0{
            preference = "Dislike"
        } else if button == 1{
            preference = "Maybe"
        } else{
            preference = "Like"
        }
        
        
        record["Preference__c"] = preference
        record["Possible_Interest__c"] = interestId
        record["Student__c"] = contactId
       
        print(record)
       
        
//        var event = [String : Any]()
//        event["TargetX_Eventsb__Contact__c"] = contactId
//        event["TargetX_Eventsb__OrgEvent__c"] = "a0JG000000VTLttMAH"
//        event["TargetX_Eventsb__Confirmed__c"] = true
//        
//        
//        let eventRequest = RestClient.shared.requestForUpsert(withObjectType: "TargetX_Eventsb__ContactScheduleItem__c", externalIdField: "Id", externalId: nil, fields: event)
//        //let selectedInterestRequest = RestClient.shared.requestForCreate(withObjectType: "Selected_Interest__c", fields: record)
//        RestClient.shared.send(request: eventRequest, onFailure: { (error, URLResponse) in
//            SalesforceLogger.d(type(of:self), message:"Error invoking while sending upsert request: \(eventRequest), error: \(error)")
//            
//        }){(response, URLResponse) in
//            //Creates a save alert to be presented whenever the user saves their information
//            os_log("\nSuccessful response received")
//        }
//        
        
        let selectedInterestRequest = RestClient.shared.requestForUpsert(withObjectType: "Selected_Interest__c", externalIdField: "Id", externalId: nil, fields: record)
       //let selectedInterestRequest = RestClient.shared.requestForCreate(withObjectType: "Selected_Interest__c", fields: record)
        RestClient.shared.send(request: selectedInterestRequest, onFailure: { (error, URLResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking while sending upsert request: \(selectedInterestRequest), error: \(error)")
            
        }){(response, URLResponse) in
            //Creates a save alert to be presented whenever the user saves their information
            os_log("\nSuccessful response received")
        }
    }
    
    @IBAction func WebsiteButton(_ sender: UIButton) {
        self.show(websiteUrl)
    }
    
    @IBAction func ContactButton(_ sender: UIButton) {
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        loadFromStore()
        
        let button = sender.tag
        pushUsingSalesforce(button)
        
    }
    @IBAction func dislikeButton(_ sender: UIButton) {
        loadFromStore()
        let button = sender.tag
        pushUsingSalesforce(button)
        
    }
    
    @IBAction func maybeButton(_ sender: UIButton) {
        loadFromStore()
        let button = sender.tag
        pushUsingSalesforce(button)
    }
    
    
    //Takes a url as a parameter, and then makes it appear with an internal safari page.
    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
