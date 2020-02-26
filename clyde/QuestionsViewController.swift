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
    @IBOutlet weak var linkToFaq: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        //reveals menu
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        linkToFaq.titleLabel?.numberOfLines = 3
        linkToFaq.titleLabel?.lineBreakMode = .byWordWrapping
        linkToFaq.titleLabel?.adjustsFontSizeToFitWidth = true
    }


    @IBAction func toFaq(_ sender: UIButton) {
        
        show("http://admissions.cofc.edu/faq/index.php")
    }
    


    override func loadView() {
        super.loadView()
    }

    
//-------------------------------------------------------------------------
// MARK: Helper functions
    
    
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
