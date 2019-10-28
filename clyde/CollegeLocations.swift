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
    var building: String?
    var buildingDescription: String?
    
    init(coordinate: CLLocationCoordinate2D, building: String?, buildingDescription: String?){
        self.coordinate = coordinate
        self.building = building
        self.buildingDescription = buildingDescription
    }
}
