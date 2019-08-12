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
    
    var websiteUrl = ""
    @IBOutlet weak var majorImage: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorDescription: UITextView!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var majorsDictionary = ["Accounting", "African American Studies", "Anthropology", "Archaeology", "ArtHistory", "Arts Management", "Astronomy", "Astrophysics", "Biochemistry", "Biology", "Business Administration", "Chemistry", "Classics" , "Communicaion", "Commercial Real Estate", "Computer Information Systems", "Computer Science", "Computing in the Arts", "Dance", "Data Science", "Early Childhood Education", "Economics", "Elementary Education", "English", "Exercise Science", "Finance", "Foreign Language Education", "French", "Geology", "General Studies","German", "Historic Preservation and Community Planning","History","Hospitality and Tourism Management", "International Business", "International Studies", "Jewish Studies", "Latin American and Caribbean Studies", "Marine Biology", "Marketing","Mathematics", "Meteorology", "Middle Grades Education", "Music", "Philosophy", "Physical Education", "Physics", "Political Science", "Psychology", "Public Health, B.A.", "Public Health, B.S.", "Religious Studies", "Secondary Education", "Sociology", "Spanish", "Special Education", "Studio Art", "Supply Chain Management", "Theatre", "Urban Studies", "Women's and Gender Studies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
    }
    
    override func loadView() {
        super.loadView()
        self.loadFromStore()
    }
    

    func loadFromStore(){
        let querySpec = QuerySpec.buildSmartQuerySpec(smartSql: "select {Major:Name},{Major:Website__c},{Major:Description__c},{Major:Image_Url__c} from {Major}", pageSize: 60)
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
                        

                    }
                }
                task.resume()
            }
        }catch let e as Error?{
            print(e as Any)
        }
    }
    
    
    @IBAction func WebsiteButton(_ sender: UIButton) {
    }
    
    @IBAction func ContactButton(_ sender: UIButton) {
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        loadFromStore()
    }
    @IBAction func dislikeButton(_ sender: UIButton) {
    }
    
    @IBAction func maybeButton(_ sender: UIButton) {
    }
}
