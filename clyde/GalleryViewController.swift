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
    
    //adds the ability to refresh the page
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the menu bar
        self.menuBar(menuBarItem: menuBarButton)
        
        // Adds the cofc logo to the nav
        
        self.addLogoToNav()
        
        //sets the scroll view content size
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+780)
        //can only bounce vertically, not horizontally
        scrollView.alwaysBounceVertical = true
        //indicates that scrolling has entered the end of content
        scrollView.bounces  = true
        
        //Adds the didPullToRefresh function to the refresh action, causing image url changes
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)
        
        //the inital import gallery
        importGallery()
    }
    
    ///If you ever want to add more images to the gallery, they would go here.
    ///Here is where you add an image url to have it imported into the gallery image list.
    var imageAddresses = ["https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN25&oid=00D540000001Vbx&lastMod=1576246546000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2K&oid=00D540000001Vbx&lastMod=1576246692000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2e&oid=00D540000001Vbx&lastMod=1576247060000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2o&oid=00D540000001Vbx&lastMod=1576247171000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN2t&oid=00D540000001Vbx&lastMod=1576247208000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN33&oid=00D540000001Vbx&lastMod=1576247331000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN41&oid=00D540000001Vbx&lastMod=1576247415000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN5E&oid=00D540000001Vbx&lastMod=1576247828000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN5x&oid=00D540000001Vbx&lastMod=1576248302000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN62&oid=00D540000001Vbx&lastMod=1576248397000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN6C&oid=00D540000001Vbx&lastMod=1576248512000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nN6M&oid=00D540000001Vbx&lastMod=1576248566000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLc&oid=00D540000001Vbx&lastMod=1576257552000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLm&oid=00D540000001Vbx&lastMod=1576257642000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLr&oid=00D540000001Vbx&lastMod=1576257704000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNLw&oid=00D540000001Vbx&lastMod=1576257760000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNfB&oid=00D540000001Vbx&lastMod=1576262465000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNff&oid=00D540000001Vbx&lastMod=1576263081000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000nNgE&oid=00D540000001Vbx&lastMod=1576263582000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHP2&oid=00D540000001Vbx&lastMod=1578930223000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHQj&oid=00D540000001Vbx&lastMod=1578930614000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHV1&oid=00D540000001Vbx&lastMod=1578930867000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHVB&oid=00D540000001Vbx&lastMod=1578931109000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHbF&oid=00D540000001Vbx&lastMod=1578934569000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHen&oid=00D540000001Vbx&lastMod=1578935562000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHj0&oid=00D540000001Vbx&lastMod=1578935711000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHj5&oid=00D540000001Vbx&lastMod=1578935870000", "https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHrQ&oid=00D540000001Vbx&lastMod=1578936211000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHra&oid=00D540000001Vbx&lastMod=1578936313000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHrp&oid=00D540000001Vbx&lastMod=1578936431000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHrz&oid=00D540000001Vbx&lastMod=1578936545000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHsO&oid=00D540000001Vbx&lastMod=1578936647000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHsT&oid=00D540000001Vbx&lastMod=1578936969000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHsd&oid=00D540000001Vbx&lastMod=1578937022000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHsn&oid=00D540000001Vbx&lastMod=1578937326000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHss&oid=00D540000001Vbx&lastMod=1578937364000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHsx&oid=00D540000001Vbx&lastMod=1578937398000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHt7&oid=00D540000001Vbx&lastMod=1578937666000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHym&oid=00D540000001Vbx&lastMod=1578938404000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHyr&oid=00D540000001Vbx&lastMod=1578938434000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oHyw&oid=00D540000001Vbx&lastMod=1578938564000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI0J&oid=00D540000001Vbx&lastMod=1578938638000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI4l&oid=00D540000001Vbx&lastMod=1578939472000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI4q&oid=00D540000001Vbx&lastMod=1578939515000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI4v&oid=00D540000001Vbx&lastMod=1578939547000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI50&oid=00D540000001Vbx&lastMod=1578939594000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI55&oid=00D540000001Vbx&lastMod=1578939621000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI5P&oid=00D540000001Vbx&lastMod=1578939824000","https://c.cs40.content.force.com/servlet/servlet.ImageServer?id=01554000000oI5U&oid=00D540000001Vbx&lastMod=1578939874000"]
    
    
  

    /// Displays the image urls for every image within the gallery
    func importGallery(){
        var count = 0
        let index = imageAddresses.count
        let numbers = randomSequenceGenerator(min: 0, max: index-1)
        for image in imageViewList{
            var num = numbers()
            urlToImage(imageUrlString: imageAddresses[num], image: image)
        }
    }
    
    /// Refresh function, calls import gallery to create a new sequence of images.
    @objc func didPullToRefresh() {
        
        importGallery()
        
        // For End refrshing
        refreshControl?.endRefreshing()
        
        
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

