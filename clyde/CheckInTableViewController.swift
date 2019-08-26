//
//  CheckInTableViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/10/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import SmartSync

class CheckInTableViewController: UITableViewController {
    var events : [Dictionary<String,Any>] = []
    var contactId = ""
    var eventId: String!
    var contactSchedId: String!
    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    let mylog = OSLog(subsystem: "edu.cofc.clyde", category: "Registered Events")
    
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!

    /// Init for the events list data source
    /// Displays the student's registered events on the table view.
    private let dataSource = EventsDataSource(cellReuseIdentifier: "sampleEvent") { record, cell in
        let eventName = record["TargetX_Eventsb__OrgEvent__c"] as? String ?? ""
        cell.textLabel?.text = eventName
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Determines the height of each row
        tableView.rowHeight = 40
        // Indicated whether the controller will clear the selection when the table appears
        self.clearsSelectionOnViewWillAppear = false
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        // Adds the cofc logo to the nav
        self.addLogoToNav()
        // Returns the contact id
        self.contactId = getContactId()
        
        // Sets the table data source
        self.dataSource.delegate = self as! EventsDataSourceDelegate
        self.tableView.delegate = self
        self.tableView.dataSource = self.dataSource
        // Inits a UIRefreshControl and adds the target
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self.dataSource, action: #selector(self.dataSource.fetchData), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl!)
        // Executes the soqlQuery
        self.dataSource.fetchData()
    }
    
    override func loadView() {super.loadView()}
    
    
    /// Pulls the student's registered events
    /// Deprecated
    private func requestListOfRegisteredEvents(){
         var id = self.getContactId()
        let request = RestClient.shared.request(forQuery: "SELECT TargetX_Eventsb__OrgEvent__c,Id FROM TargetX_Eventsb__ContactScheduleItem__c WHERE TargetX_Eventsb__Contact__c = '\(id)'")
        RestClient.shared.send(request: request, onFailure: { (error, urlResponse) in
            SalesforceLogger.d(type(of:self), message:"Error invoking: \(error)")
        }) { [weak self] (response, urlResponse) in
            
            guard let strongSelf = self,
                let jsonResponse = response as? Dictionary<String,Any>,
                let result = jsonResponse ["records"] as? [Dictionary<String,Any>]  else {
                    return
            }
           print(result)
            DispatchQueue.main.async {
                self!.events = result
            }
        }    }
    
    
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
        print("you selected \(indexPath.row)")
        
        // Get the cell label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        eventId = currentCell.textLabel?.text
        performSegue(withIdentifier: "ViewEventDetails", sender: self)
    }
    
    /// Displays the table header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Creates a uiview
        let view = UIView()
        // Sets the background color of the uiview
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Image name
        let imageString = "Clyde-Campus-Tour.jpg"
        // Creates the image
        let image = UIImage(named: imageString)
        // Creates the image view
        let imageView = UIImageView(image: image!)
        // Creates the image frame
        imageView.frame = CGRect(x: 0, y: 0, width: 422, height: 150
        )
        // Sets the image transparency
        imageView.alpha = 0.75
        // Sets the image content mode
        imageView.contentMode = .scaleAspectFill
        // Places the imageView onto the uiView
        view.addSubview(imageView)
        // Creates a label
        let label = UILabel()
        // Adds text to the label
        label.text = "Your Registered Events"
        // Sets the label background color
        label.backgroundColor = #colorLiteral(red: 0.9546924233, green: 0.259139955, blue: 0.2854149044, alpha: 1)
        // Sets the label font
        label.font = UIFont(name: "Avenir Next Regular", size: 25.0)
        // Sets label text color and alignment
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        //
        label.frame = CGRect(x: 0, y: 142.67, width:414, height: 40)
        view.addSubview(label)
        
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 182.67
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ViewEventDetails"){
            var detailsViewController = segue.destination as! EventDetailViewController
            detailsViewController.capturedEventId = eventId
            print("event id is \(eventId)")
        }
        
        
    }

    
    
    /// Pulls user's contact id
    ///
    /// - Returns: contact id
    func getContactId() -> String{
        
        var id = ""
        let userQuery = QuerySpec.buildSmartQuerySpec(smartSql: "select {Contact:Id} from {Contact}", pageSize: 1)
        do{
            let records = try self.store.query(using: userQuery!, startingFromPageIndex: 0)
            guard let record = records as? [[String]] else{
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)
                print(records)
                return "no"
            }
            
            id = record[0][0] as! String
            return id

            DispatchQueue.main.async {
                
                DispatchQueue.main.async {
                    self.contactId = id
                    
                }
            }
            
        }catch let e as Error?{
            print(e as Any)
        }
        return id
    }
}
extension CheckInTableViewController: EventsDataSourceDelegate {
    func EventsDataSourceDidUpdateRecords(_ dataSource: EventsDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}
