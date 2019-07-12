//
//  CheckInTableViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/10/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class CheckInTableViewController: UITableViewController {

   
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.menuBar(menuBarItem: menuBarButton)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
