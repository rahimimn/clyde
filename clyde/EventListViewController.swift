//
//  EventListViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 8/23/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()

}
}
