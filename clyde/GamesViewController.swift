//
//  GameViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/11/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

///Games View Controller
///
///Simple UI menu for the games avaiable in the iOS app
class GamesViewController: UIViewController {

    
    //----------------------------------------------------------
    // MARK: Outlets
    //Menu button
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    //----------------------------------------------------------
    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adds menu bar controller
        self.menuBar(menuBarItem: menuBarButton)
        //Adds cofc logo to nav bar
        self.addLogoToNav()
    }
    
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    

   

}
