//
//  EventsTableViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/26/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit


/// Class for event registration
class EventsTableViewController: UIViewController {

    
    // TO-DO: pull the list of available events from salesforce, present the information within the tableView.
    // When user taps on an event, present a form that allows them to sign up for the event.
    // Request access to user's calendar, to add the event.
    
    
    
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
        
    }
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
    }

    

}
