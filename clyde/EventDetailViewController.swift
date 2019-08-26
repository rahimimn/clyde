//
//  CheckInViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/21/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import SwiftyJSON
import Foundation

class EventDetailViewController: UIViewController {

    
    var capturedEventId : String?

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var qrView: UIImageView!
    
    /// Action Button that performs a segue back to the orignial page
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    //Create an instance of CoreImage filter with the name "CIQRCodeGenerator", which lets us reference Swift's built-in QR code generation through the Core Image framework.
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
           
            
            guard let qrCodeImage = filter.outputImage else{ return nil }
            
            let scaleX = qrView.frame.size.width / qrCodeImage.extent.size.width
            let scaleY = qrView.frame.size.height / qrCodeImage.extent.size.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        
        
        let array = capturedEventId?.split(separator: " ")
        let id = array![1]
        var imageUrl = "https://chart.googleapis.com/chart?chs=325x325&cht=qr&chl=https://cofc.tfaforms.net/217890?tfa_1="
        var url = imageUrl + id
           
        DispatchQueue.main.async {
                
                let url = URL(string: url)!
                let task = URLSession.shared.dataTask(with: url){ data,response, error in
                    guard let data = data, error == nil else {return}
                    DispatchQueue.main.async {
                        self.qrView.image = UIImage(data:data)
                       
                        
                    }
                }
                task.resume()
            }
            
        
    }
    
    override func loadView() {
        super.loadView()
        self.pullAddress()
    }
    
    func pullAddress(){
        let eventIdRequest = RestClient.shared.request(forQuery: "SELECT TargetX_Eventsb__OrgEvent__c From TargetX_Eventsb__ContactScheduleItem__c WHERE Id = '\(capturedEventId)'")
        RestClient.shared.send(request: eventIdRequest, onFailure: {(error, urlResponse) in
        }) { [weak self] (response, urlResponse) in
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String, Any>,
                let results = jsonResponse["records"] as? [Dictionary<String, Any>]
                else{
                    print("\nWeak or absent connection.")
                    return
            }
            let jsonContact = JSON(response)
            let eventOrgId = jsonContact["records"][0]["TargetX_Eventsb__OrgEvent__c"].stringValue
            DispatchQueue.main.async {
                print("--------------------------------------------------------------")
                print("here lies the event org id\(eventOrgId)")

            }
        }
        
    }//func
    
    
    
    func createMap(){
        
    }
    
}
