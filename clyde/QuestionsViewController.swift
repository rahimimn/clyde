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

    //----------------------------------------------------------
    // MARK: Outlets
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var linkToFaq: UIButton!
    
    //----------------------------------------------------------
    // MARK: Button Action
    @IBAction func toFaq(_ sender: UIButton) {
       show("http://admissions.cofc.edu/faq/index.php")
    }
    
    
    //----------------------------------------------------------
    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()        //reveals menu
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        linkToFaq.titleLabel?.numberOfLines = 3
        linkToFaq.titleLabel?.lineBreakMode = .byWordWrapping
        linkToFaq.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
    }
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
