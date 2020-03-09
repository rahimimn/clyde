//
//  BingoViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 3/4/20.
//  Copyright © 2020 Salesforce. All rights reserved.
//

import UIKit

class BingoViewController: UIViewController {
    
    
    @IBOutlet var bingoBoards: [UIButton]!
    
    var bingoStrings = ["MUSC","Famous Alumni", "The Cistern", "Grad Ceremony", "Historic","Sotitile Theatre","Spoleto Festival","Jewish Studies", "Fraternity Row","Stern Center","Brick Walkways","Honors", "Addlestone Library"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStrings()

        // Do any additional setup after loading the view.
    }
    
    func addStrings(){
        var count = 0
        let index = bingoStrings.count
        let numbers = randomSequenceGenerator(min: 0, max: index-1)
        for string in bingoStrings{
            var num = numbers()
            print(string)
            for item in bingoBoards{
               item.setTitle(string, for: .normal)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
