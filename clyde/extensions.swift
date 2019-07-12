//
//  extensions.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/12/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
import SafariServices

/// Extension for Double that removes the remainder
extension Double {
    var formatForProfile: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }}

/// Extension for the menu bar
extension UIViewController{
    func menuBar(menuBarItem: UIBarButtonItem){
        if revealViewController() != nil {
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController().revealToggle(_:))
            self.revealViewController()?.rearViewRevealWidth = 350
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
}



