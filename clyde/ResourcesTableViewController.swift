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
        return 16
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //CHANGE THESE
        let urlArray = ["http://cofc.edu/","http://cofc.edu/athletics/","http://disabilityservices.cofc.edu/","https://tunein.com/radio/CisternYard-Radio-s208531/","https://cofc.campuslabs.com/engage/organizations", "https://charleston.campusdish.com/","http://orientation.cofc.edu/docs/fa19newstudentcalendar.pdf","http://finaid.cofc.edu/students/incoming-freshmen/index.php","https://cofc.secure.force.com/TravelLookup/?_ga=2.99755421.2063692641.1562763558-124322718.1558454919","http://greeks.cofc.edu/","https://www.youvisit.com/tour/cofc/140487?pl=v&m_prompt=1","http://honors.cofc.edu/admission/","http://www.cofc.edu/campuslife/lifeincharleston/index.php","http://parkingservices.cofc.edu/","http://finaid.cofc.edu/types-of-financial-aid/scholarships/","http://housing.cofc.edu/residence-halls/"]
        
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
