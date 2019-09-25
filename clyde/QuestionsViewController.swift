//
//  QuestionsViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import Foundation
import SalesforceSDKCore
import SwiftyJSON

 //TO-DO: Create a chat system between user and counselors or tour guides.

class QuestionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var TextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()        //reveals menu
       self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
    }





    override func loadView() {
        super.loadView()
        
        var image = UIImage(named: "clyde.jpg")
        let data = image?.jpegData(compressionQuality: 1.0) as NSData?
    
        let b64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        //print(b64)
        let fields = [
            "Name": "John's",
            "Body": b64,
            "FolderId":"00l54000000GCPI",
            "IsInternalUseOnly":"false"
        ]
        
        let attachmentRequest = RestClient.shared.requestForCreate(withObjectType: "Documents", fields: fields)
        RestClient.shared.send(request: attachmentRequest, onFailure: {(error, urlResponse) in
                        print(error!)
                    }) { [weak self] (response, urlResponse) in
                        print(response)
                       
                    }
        
    }
    
        
//        let uploadRequest = RestClient.shared.request(forUploadFile: data! as Data, name: "StudentProfilePhoto", description: "testing file upload from clydeClub app", mimeType: "image/jpg")
//        RestClient.shared.send(request: uploadRequest, onFailure: {(error, urlResponse) in
//            print(error!)
//        }) { [weak self] (response, urlResponse) in
//            print(response)
//            }
//
    
        
        
//
//
//        let dataRequest = RestClient.shared.request(forQuery: "SELECT OwnerId,Title FROM ContentDocument WHERE OwnerId = '005540000026ZWJAA2'")
//        RestClient.shared.send(request: dataRequest, onFailure: {(error, urlResponse) in
//            print(error!)
//        }) { [weak self] (response, urlResponse) in
//            print(response)
//            let jsonResponse = JSON(response!)
//            let id = jsonResponse["Title"].stringValue
//            DispatchQueue.main.async {
//                print("here we go again")
//                print(id)
//            }
//
//        }}



}
