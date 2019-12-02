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
        urlToImage(imageUrlString: "https://c.cs40.content.force.com/sfc/dist/version/download/?oid=00D540000001Vbx&ids=0680f000004y7IW&d=%2Fa%2F0f000000U0o1%2F3nhjuUujuAwZWtIxj_xrRdC2fIYR9ZYH4FzHqmi5_EE&asPdf=false")
    }
    

    func dostuff(){
        
        
       
        
        //let data = Data(base64Encoded: imageData)!
        //let imaged = UIImage(data: data)
        
        //image.image = imaged
        
        
        //let pushRequest = RestClient.shared.request(forFileContents: "06854000000TCVr", version: nil)
        //let pushRequest = RestClient.shared.request(forQuery: "SELECT ContentDownloadUrl,DistributionPublicUrl,PdfDownloadUrl FROM ContentDistribution")
        let pushRequest = RestClient.shared.request(forQuery: "SELECT Id FROM Document")
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
            guard let data = data, error == nil else {return}
            print(error)
            DispatchQueue.main.async {
                print(url)
                self.image.image = UIImage(data:data)
            }
        }
        task.resume()    }
    

}

