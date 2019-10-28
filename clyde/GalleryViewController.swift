//
//  GalleryViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        // Adds the cofc logo to the nav
        self.addLogoToNav()        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
