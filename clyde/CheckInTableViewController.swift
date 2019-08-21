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

    var contactId = ""
    var store = SmartStore.shared(withName: SmartStore.defaultStoreName)!
    let mylog = OSLog(subsystem: "edu.cofc.clyde", category: "Registered Events")
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.menuBar(menuBarItem: menuBarButton)
        self.addLogoToNav()
        self.getContactId()
        
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
    
    
    /// Saves the contact's id
    func getContactId(){
        let userQuery = QuerySpec.buildSmartQuerySpec(smartSql: "select {Contact:Id} from {Contact}", pageSize: 1)
        do{
            let records = try self.store.query(using: userQuery!, startingFromPageIndex: 0)
            guard let record = records as? [[String]] else{
                os_log("\nBad data returned from SmartStore query.", log: self.mylog, type: .debug)
                print(records)
                return
            }
            
            let id = record[0][0]
            
            DispatchQueue.main.async {
                
                
                DispatchQueue.main.async {
                    self.contactId = id
                    
                }
            }
            
        }catch let e as Error?{
            print(e as Any)
        }
    }
    
    private let dataSource = CheckInTableDataSource(soqlQuery: "SELECT Name,TargetX_Eventsb__event_end_date__c FROM TargetX_Eventsb__ContactScheduleItem__c WHERE Id = '0035400000GV18bAAD'", cellReuseIdentifier: "CasePrototype") { record, cell in
        let name = record["Name"] as? String ?? ""
        let date = record["TargetX_Eventsb__event_end_date__c"] as? String ?? ""
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "Date: \(date)"
    }
 
}

extension CheckInTableViewController: CheckInTableDataSourceDelegate {
    func checkInTableDataSourceDidUpdateRecords(_ dataSource: CheckInTableDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}

