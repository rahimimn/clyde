//
//  SlideInTableViewController.swift
//  clydeClubIos
//
//  Created by Rahimi, Meena Nichole (Student) on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class SlideInTableViewController: UIViewController, UITableViewDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
     //MARK: - Navigation
    

    
    
    
    
    
/*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: UIViewController?
        switch indexPath.row {
        
        case 0: //For "one"
            controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        case 1: //For "one"
            controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView")
        case 2: //For "two"
            controller = self.storyboard?.instantiateViewController(withIdentifier:"MajorsView")
        case 3: //For "three"
            controller = self.storyboard?.instantiateViewController(withIdentifier:"CounselorView")
        case 4: //For "four"
            controller = self.storyboard?.instantiateViewController(withIdentifier:"EventsView")
        case 5:
            controller = self.storyboard?.instantiateViewController(withIdentifier:"QuestionsView")
        default:
            controller = self.storyboard?.instantiateViewController(withIdentifier:"HomeView")
        }
        if (controller != nil) {
            let cell = tableView.cellForRow(at: indexPath)
            controller!.title = cell?.textLabel?.text
            let navController = UINavigationController(rootViewController: controller!)
            revealViewController().pushFrontViewController(navController, animated:true)
        }
    }*/
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
