//
//  LaunchViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/25/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        saveImage()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func saveImage() {
        let bottomImage = UIImage(named: "your bottom image name")!
        let topImage = UIImage(named: "your top image name")!
        
        let newSize = CGSize(width: 100, height: 100)   // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        topImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
}
