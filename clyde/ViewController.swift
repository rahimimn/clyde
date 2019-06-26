//
//  ViewController.swift
//  clydeClubIos
//
//  Created by Rahimi, Meena Nichole (Student) on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SafariServices


class HomeViewController: UIViewController{

    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController().revealToggle(_:))
            self.revealViewController()?.rearViewRevealWidth = 350
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    //Homepage news button articles. These will eventually have to be replaced to allow automation.
    @IBAction func clickFirst(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/24/beat-the-heat-public-health-heat-related-illness/")}
    
    @IBAction func clickSecond(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/21/jarrell-brantley-nba-draft/")}
    
    @IBAction func clickThird(_ sender: UIButton) {
        show("https://today.cofc.edu/2019/06/12/college-of-charleston-orientation-2019/")}
    
    @IBAction func clickMore(_ sender: UIButton) {
        show("https://today.cofc.edu/")}
    
    
    //When called, this function will present the url (parameter) within the app using a SafariViewController.
    func show(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func clickToEvents(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueFromHomeToEvents", sender: self)
    }
    
    
}
    
    
       

    

