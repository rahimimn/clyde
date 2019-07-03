//
//  ResourcesTableViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/1/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SafariServices

class ResourcesTableViewController: UITableViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //CHANGE THESE
        let urlArray = ["https://www.cofc.edu/", "https://charleston.campusdish.com/","http://housing.cofc.edu/residence-halls/","http://parkingservices.cofc.edu/","http://finaid.cofc.edu/students/incoming-freshmen/index.php","https://www.youvisit.com/tour/cofc/140487?pl=v&m_prompt=1","http://cofc.edu/athletics/","https://www.mapdevelopers.com/distance_from_to.php","http://greeks.cofc.edu/","http://honors.cofc.edu/admission/"]
        
        let urlString = urlArray[indexPath.row]
        show(urlString)
    
    }

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
