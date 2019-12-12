//
//  GalleryViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SmartSync
import SwiftyJSON

class GalleryViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        // Adds the cofc logo to the nav
        self.addLogoToNav()        // Do any additional setup after loading the view.
        dostuff()
        //doDifferentStuff()
        urlToImage(imageUrlString: "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000dtUX&oid=00D540000001Vbx&lastMod=1564422940000")
    }
    

    
    //https://cs40.salesforce.com/services/data/v46.0/sobjects/Document/01554000000dtUXAAY/body -H "Authorization: Bearer token"
    
    func doDifferentStuff(){
        let request = RestRequest(method: .GET, serviceHostType: .instance, path:"/services/data/v46.0/sobjects/Document/01554000000dtUXAAY", queryParams: nil)
        RestClient.shared.send(request: request, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking: \(request)")
            print(error)
        }) {(self, response) in
            os_log("\nSuccessful response received")
            print(response)
        }
    }

    func dostuff(){
        
        
       print("do stuff")
        
        //let data = Data(base64Encoded: imageData)!
        //let imaged = UIImage(data: data)
        
        //image.image = imaged
        
        
        //let pushRequest = RestClient.shared.request(forFileContents: "06854000000TCVr", version: nil)
        //let pushRequest = RestClient.shared.request(forQuery: "SELECT ContentDownloadUrl,DistributionPublicUrl,PdfDownloadUrl FROM ContentDistribution")
       // let pushRequest = RestClient.shared.request(forQuery: "SELECT VersionData FROM ContentVersion WHERE FirstPublishLocationId = '058540000006unNAAQ'")
        let pushRequest = RestClient.shared.request(forQuery: "SELECT Body FROM Document WHERE Id = '01554000000dtUX'")
        RestClient.shared.send(request: pushRequest, onFailure: {(error, urlResponse) in
            print(error)

        }) { [weak self](response, urlResponse) in
            let jsonResponse = JSON(response!)
            print(jsonResponse)


            }
        
    }
    
    func urlToImage(imageUrlString: String){
        let url = URL(string: imageUrlString)!
        
        let task = URLSession.shared.dataTask(with: url){ data,response, error in
            guard let data = data, error == nil else {
                print(error)
                return}
            print(error)
            DispatchQueue.main.async {
                print(url)
                self.image.image = UIImage(data:data)
            }
        }
        task.resume()    }
    

}

