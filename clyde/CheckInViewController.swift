//
//  CheckInViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/21/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
 
    @IBOutlet weak var qrView: UIImageView!
    
    
    //Create an instance of CoreImage filter with the name "CIQRCodeGenerator", which lets us reference Swift's built-in QR code generation through the Core Image framework.
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
           
            
            guard let qrCodeImage = filter.outputImage else{ return nil }
            
            let scaleX = qrView.frame.size.width / qrCodeImage.extent.size.width
            let scaleY = qrView.frame.size.height / qrCodeImage.extent.size.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = generateQRCode(from: "003S0000017xFExIAM")
        qrView.image = image
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }

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

}
