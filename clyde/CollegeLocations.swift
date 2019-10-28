//
//  CollegeLocations.swift
//  
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//

import Foundation
import UIKit
import MapKit

class CollegeLocation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var buildingDescription: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, buildingDescription: String?){
        self.coordinate = coordinate
        self.title = title
        self.buildingDescription = buildingDescription
    }
}
