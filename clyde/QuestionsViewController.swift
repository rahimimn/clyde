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
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        //reveals menu
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 2
    }





    override func loadView() {
        super.loadView()
    }

}
