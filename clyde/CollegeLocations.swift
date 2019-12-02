//
//  CollegeLocations.swift
//  
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//

import Foundation
import UIKit
import MapKit
/// College Location instance created for a map, manipulating Annotations
class CollegeLocation: NSObject, MKAnnotation{
    
    //---------------------------------------------------------
    // MARK: variables
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var buildingDescription: String?
    
    //----------------------------------------------------------
    // MARK: Initialize
    init(coordinate: CLLocationCoordinate2D, title: String?, buildingDescription: String?){
        self.coordinate = coordinate
        self.title = title
        self.buildingDescription = buildingDescription
    }
}
