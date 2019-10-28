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
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 0, longitudinalMeters: 0)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        
        
        
    
    }
    
  
    
    // -----------------------------------------------------------------------------
    // MARK: Map Functions
    func addLocation(building: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, description: String) {
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let pin = CollegeLocation(coordinate: coordinates)
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
            let annotationDescription = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            annotationDescription.text = collegeAnnotation.buildingDescription
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -8,y: 0)
            annotationView.autoresizesSubviews = true
            annotationView.annotation = annotation
            
            
        
        return annotationView
    }
    
}
