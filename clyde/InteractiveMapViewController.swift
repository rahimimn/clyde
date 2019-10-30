//
//  InteractiveMapViewController.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 10/28/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import MapKit

class InteractiveMapViewController: UIViewController, MKMapViewDelegate {

  
    

    // -----------------------------------------------------------------------------
    // MARK: Variables and Outlets
    
    // A reference to the location manager
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // -----------------------------------------------------------------------------
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adds the cofc logo to the nav
        self.addLogoToNav()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Show the user current location
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 10, longitudinalMeters: 10)
            mapView.setRegion(viewRegion, animated: false)
        }
        

        
        self.placeAll()
    
    }
    
  
    
    // -----------------------------------------------------------------------------
    // MARK: Map Functions
    func addLocation(building: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, description: String) {
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let pin = CollegeLocation(coordinate: coordinates, title: building, buildingDescription: description)
        pin.title = building
        self.mapView.addAnnotation(pin)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation{
            return nil
        }
        
        let annotationIdentifier = "CollegeLocation"
        var annotationView: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
       
        let collegeAnnotation = annotation as! CollegeLocation
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView.image = UIImage(named: "emoji.png")
        
        
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.numberOfLines = 20
        descriptionLabel.text = collegeAnnotation.buildingDescription
       
        annotationView!.detailCalloutAccessoryView = descriptionLabel
        
        
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -8,y: 0)
        annotationView.autoresizesSubviews = true
        annotationView.annotation = annotation
       
        
        return annotationView
    }
    
    
    func placeAll(){
        addLocation(building: "Maybank Hall", latitude: 32.784818, longitude: -79.937572, description: "Maybank Hall was built in 1974, and was used as the main classroom facility on the College campus. Now, this building is used as classrooms, classroom auditoriums, and faculty offices.")
        addLocation(building: "Randolph Hall", latitude: 32.784023, longitude: -79.937419, description: "Built in 1828, it is one of the oldest college building still in use in the United States. Randolph Hall served as the main academic building for many years, but now it is primarily used for administrative offices.")
    }
}
