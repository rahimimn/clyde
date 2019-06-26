//
//  CounselorViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class CounselorViewController: UIViewController {

    var name: String = ""
    var about: String = ""
    var email: String = ""
    var id: String = ""
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    
    
    func getId(){
        var counselorId: String = ""
        let request = RestClient.shared.request(forQuery: "SELECT OwnerId FROM Contact WHERE Name = 'John Doe'")
        RestClient.shared.send(request: request, onFailure: { (error, urlResponse) in
        SalesforceLogger.d(type(of:self), message:"Error invoking: \(request)")
        }) { [weak self] (response, urlResponse) in
        
        if let JSON = response as? Dictionary<String,Any>{
        if let records = JSON["records"] as? [Dictionary<String, Any>]{
        for record in records{
            counselorId = record["OwnerId"] as? String ?? ""
        
            }}}}}
            
            
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
 

}

