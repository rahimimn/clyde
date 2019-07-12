//
//  MajorsViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/20/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

// TO-DO: functions that allow the user to determine whether they like the major or not, and depending on input, perform some action
//  like: add to list of majors the student is interested in and remove from array/dictionary
//  maybe: add to list of majors the student is interested in and remove from array
//  dislike: remove from array

class MajorsViewController: UIViewController {


    
    @IBOutlet weak var majorImage: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorDescription: UITextView!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var majorsDictionary = ["Acconting", "African American Studies", "Anthropology", "Archaeology", "ArtHistory", "Arts Management", "Astronomy", "Astrophysics", "Biochemistry", "Biology", "Business Administration", "Chemistry", "Classics" , "Communicaion", "Commercial Real Estate", "Computer Information Systems", "Computer Science", "Computing in the Arts", "Dance", "Data Science", "Early Childhood Education", "Economics", "Elementary Education", "English", "Exercise Science", "Finance", "Foreign Language Education", "French", "Geology", "General Studies","German", "Historic Preservation and Community Planning","History","Hospitality and Tourism Management", "International Business", "International Studies", "Jewish Studies", "Latin American and Caribbean Studies", "Marine Biology", "Marketing","Mathematics", "Meteorology", "Middle Grades Education", "Music", "Philosophy", "Physical Education", "Physics", "Political Science", "Psychology", "Public Health, B.A.", "Public Health, B.S.", "Religious Studies", "Secondary Education", "Sociology", "Spanish", "Special Education", "Studio Art", "Supply Chain Management", "Theatre", "Urban Studies", "Women's and Gender Studies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBar(menuBarItem: menuBarButton)
    }
    

}
