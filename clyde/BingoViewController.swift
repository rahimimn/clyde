//
//  BingoViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 3/4/20.
//  Copyright © 2020 Salesforce. All rights reserved.
//

import UIKit

class BingoViewController: UIViewController {
    
    //----------------------------------------------------------
    // MARK: Outlets
    
    @IBOutlet var bingoBoards: [UIButton]!
    
    //----------------------------------------------------------
    // MARK: Variables
    
    var bingoStrings = ["MUSC","Famous Alumni", "The Cistern", "Grad Ceremony", "Historic","Sotitile Theatre","Spoleto Festival","Jewish Studies", "Fraternity Row","Stern Center","Brick Walkways","Honors", "Addlestone Library"]
    
    //----------------------------------------------------------
    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStrings()
    }
    
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    //----------------------------------------------------------
    // MARK: Helper functions
    
    func addStrings(){
        let index = bingoStrings.count
        let numbers = randomSequenceGenerator(min: 0, max: index-1)
        for string in bingoStrings{
            _ = numbers()
            print(string)
            for item in bingoBoards{
               item.setTitle(string, for: .normal)
            }
        }
        
    }
    

    

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
