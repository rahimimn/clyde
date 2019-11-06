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

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        // Adds the cofc logo to the nav
        self.addLogoToNav()        // Do any additional setup after loading the view.
        dostuff()
    }
    

    func dostuff(){
        let pushRequest = RestClient.shared.request(for)
        
        
        (forOwnedFilesList: "0035400000GV18bAAD", page: 10)
        print(pushRequest)
            
                
            }
            
        
    

}

