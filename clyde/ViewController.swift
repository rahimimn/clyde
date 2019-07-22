//
//  ViewController.swift
//  clydeClubIos
//
//  Created by Rahimi, Meena Nichole (Student) on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON
import SalesforceSDKCore


class HomeViewController: UIViewController{


    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarItem)
        
    }
    
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickFirst(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/24/beat-the-heat-public-health-heat-related-illness/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickSecond(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/21/jarrell-brantley-nba-draft/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickThird(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/12/college-of-charleston-orientation-2019/")}
    
    /// Will present the article webpage when tapped
    ///
    /// - Parameter sender: the UIButton tapped
    @IBAction func clickMore(_ sender: UIButton) {
        show("https://today.cofc.edu/")}
    
    
    /// Displays the url as a Safari view controller
    ///
    /// - Parameter url: the url to be displayed.
    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }




  
    

    









}
    
    
       

    

