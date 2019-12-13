//
//  GalleryViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SmartSync
import SwiftyJSON

class GalleryViewController: UIViewController {

    @IBOutlet var imageViewList: [UIImageView]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        // Adds the cofc logo to the nav
        self.addLogoToNav()        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+780)
        
        importGallery()
    }
    
    var imageAddresses = ["https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN25&oid=00D540000001Vbx&lastMod=1576246546000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2K&oid=00D540000001Vbx&lastMod=1576246692000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2e&oid=00D540000001Vbx&lastMod=1576247060000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2o&oid=00D540000001Vbx&lastMod=1576247171000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2t&oid=00D540000001Vbx&lastMod=1576247208000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN33&oid=00D540000001Vbx&lastMod=1576247331000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN41&oid=00D540000001Vbx&lastMod=1576247415000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN5E&oid=00D540000001Vbx&lastMod=1576247828000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN5x&oid=00D540000001Vbx&lastMod=1576248302000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN62&oid=00D540000001Vbx&lastMod=1576248397000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN6C&oid=00D540000001Vbx&lastMod=1576248512000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN6M&oid=00D540000001Vbx&lastMod=1576248566000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLc&oid=00D540000001Vbx&lastMod=1576257552000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLm&oid=00D540000001Vbx&lastMod=1576257642000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLr&oid=00D540000001Vbx&lastMod=1576257704000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLw&oid=00D540000001Vbx&lastMod=1576257760000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNfB&oid=00D540000001Vbx&lastMod=1576262465000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNff&oid=00D540000001Vbx&lastMod=1576263081000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNgE&oid=00D540000001Vbx&lastMod=1576263582000"]
    
    
    
    
    
    func importGallery(){
        var count = 0
        let index = imageAddresses.count
        let numbers = randomSequenceGenerator(min: 0, max: index-1)
        for image in imageViewList{
            var num = numbers()
            urlToImage(imageUrlString: imageAddresses[num], image: image)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    func urlToImage(imageUrlString: String, image: UIImageView){
        let url = URL(string: imageUrlString)!
        
        let task = URLSession.shared.dataTask(with: url){ data,response, error in
            guard let data = data, error == nil else {
                print(error)
                return}
            print(error)
            DispatchQueue.main.async {
                image.image = UIImage(data:data)
            }
        }
        task.resume()    }
    

    
    /// Random sequnce of integers based on your range parameter. This was pulled and adapted from stack overflow: https://stackoverflow.com/questions/26457632/how-to-generate-random-numbers-without-repetition-in-swift
    ///
    /// - Parameters:
    ///   - min: min number in range
    ///   - max: max number in range
    /// - Returns: returns a sequence of ints
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.isEmpty {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
}

