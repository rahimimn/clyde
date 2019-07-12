//
//  QuestionsViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

 //TO-DO: Create a chat system between user and counselors or tour guides.

class QuestionsViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //reveals menu
       self.menuBar(menuBarItem: menuBarButton)
    }
}
