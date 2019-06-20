//
//  LogInViewController.swift
//  clydeClubIos
//
//  Created by Rahimi, Meena Nichole (Student) on 6/12/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class LogInViewController: UIViewController, UITextFieldDelegate{

    
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func GoToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "SegueToSignUp", sender: self)
    }
    
    @IBAction func LogIntoAccount(_ sender: UIButton) {
        
        performSegue(withIdentifier: "SegueToMain", sender: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
    }
    
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to begin")
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        print("Editing began")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to end")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended")
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print(textField.text ?? "wELP")
    }
    
 
    
}
