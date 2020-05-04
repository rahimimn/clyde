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
    
    
    
    /// Determines whether the page can autorotate
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    /// Determines the supported orientations
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
  
    
    // -----------------------------------------------------------------------------
    // MARK: Map Functions
    func addLocation(building: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, description: String) {
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let pin = CollegeLocation(coordinate: coordinates, title: building, buildingDescription: description)
        pin.title = building
        self.mapView.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else{
            return
        }
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem.forCurrentLocation()
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            if !response.routes.isEmpty {
                let route = response.routes[0]
                DispatchQueue.main.async { [weak self] in
                    self?.mapView.removeOverlays((self?.mapView.overlays)!)

                    self?.mapView.addOverlay(route.polyline)
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else {
            return MKPolylineRenderer()
        }
        let routeRenderer = MKPolylineRenderer(overlay: overlay)
        routeRenderer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        routeRenderer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        routeRenderer.lineWidth = 6
        return routeRenderer
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
        descriptionLabel.font = UIFont(name: "Avenir Next", size: 11.0)
       
        annotationView!.detailCalloutAccessoryView = descriptionLabel
        
        
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -8,y: 0)
        annotationView.autoresizesSubviews = true
        annotationView.annotation = annotation
       
        
        return annotationView
    }
    
    // -----------------------------------------------------------------------------
    // MARK: Helper Functions
    func placeAll(){
        addLocation(building: "Maybank Hall", latitude: 32.784769, longitude: -79.937764, description: "Maybank Hall was built in 1974, and was used as the main classroom facility on the College campus. Now, this building is used as classrooms, classroom auditoriums, and faculty offices.")
        addLocation(building: "Randolph Hall", latitude: 32.784023, longitude: -79.937419, description: "Built in 1828, it is one of the oldest college building still in use in the United States. Randolph Hall served as the main academic building for many years, but now it is primarily used for administrative offices.")
        addLocation(building: "Cistern", latitude: 32.783857, longitude: -79.937305, description: "The Cistern was constructed in 1857 as a reservoir to provide water for fighting fires in the days before the city installed a water system. Later, it was covered and planted with grass, becoming a favorite study spot for students.")
        addLocation(building: "Towell Library", latitude: 32.783693, longitude: -79.937522, description: "Built in 1855, it was the first campus library. Designed in Classical Revival style, the building was named for Edward Emerson Towell, an alumnus, former chemistry professor, and Academic Dean of the college.")
        addLocation(building: "Porter's Lodge", latitude: 32.783375, longitude: -79.937042, description: "This Roman Revival-inspired building was constructed in 1850 and was the home of the College's porter, or custodian. During the Civil War, Porter's Lodge housed a fire engine; the notches that were carved to make room for the engine's shafts are still visible. Today, the building houses faculty offices.")
        addLocation(building:"Cistern Yard", latitude: 32.783672, longitude: -79.937296, description:"In 1850, the College's caretaker let his livestock roam around the Cistern yard. This was not popular with the students who had to walk back and forth across the yard to get to classes. After a lot of complaining, the cows were finally told to hit the trail and were moved to a different location. It is now where the college hold occasional events.")
        addLocation(building: "Johnson Physical Education & Silcox Physical Education and Health Center", latitude: 32.785013, longitude: -79.933662, description: "Together, these two centers house four basketball courts, five volleyball courts, six badminton courts, a space for indoor soccer, an indoor running track, a small workout area, five racquetball courts (two of which are convertible to squash courts), a 4,900 sq. ft. multi-purpose room, and locker and shower areas.")
        addLocation(building: "TD Arena", latitude: 32.785435, longitude: -79.934359, description: "The men's and women's basketball teams and the volleyball team call this 5,100-seat-state-of-the-art facility home. TD Arena opened in 2008 with expanded media areas, an expanded practice area as well as office space, and academic support area and a spacious sports medicine facility.")
        addLocation(building: "George Street Apartments", latitude: 32.783592, longitude: -79.936208, description: "George Street Apartments is a four-story building housing 199 students. Each apartment has a fully furnished living room; a kitchen with stove, microwave, sink, dishwasher, and full-size refrigerator; a washer; and a dryer. All apartments are air conditioned and come equipped with high-speed internet via Wi-Fi. All apartments overlook an open courtyard with comfortable outdoor furniture." )
        addLocation(building: "George Street Fitness Center", latitude: 32.784481, longitude: -79.936230, description: "Centrally located at 50 George Street on the first floor of the Campus Center Apartments, this 13,000 sq.ft. workout space includes state-of-the-art cardio equipment, weight machines, free weights and benches, lockers and showers.")
        addLocation(building: "Liberty Street Residence Hall", latitude: 32.783063, longitude: -79.935507, description: "Liberty is a six-story building housing approximately 430 students. A shared bathroom connects two bedrooms. The building also features game rooms, lounge areas, study rooms, and a common kitchen. Liberty has air-conditioning, high-speed internet via Wi-Fi, and a 24-hour information/security desk.")
        addLocation(building: "Liberty Street Fresh Food Company", latitude: 37.782770, longitude: -79.935881, description: "This all-you-care-to-eat dining location features unlimited buffet style options. Choose from flame-grilled entrees, brick-oven pizza, vegetarian stir-fry, pasta, or an abundant salad bar. Visit the Simple Selections station for allergy-friendly menu options!")
        addLocation(building: "Craig Residence Hall & Craig Union", latitude: 32.783141, longitude: -79.936352, description: "Craig Residence Hall is a three story, male-only building in the heart of the campus on St. Philip Street. Constructed in 1961 (Craig Union) and renovated in 2004, Craig Residence Hall is air conditioned, has high-speed internet with Wi-Fi, and features a large game/activity room, central laundry room, and 24-hour information/security desk. Craig Residence Hall is arranged with all suites opening to outside corridors or the central game/activity room. Craig has several room layouts including: a three-bedroom suite with a common room and a large, common bath; two, three, and four-bedroom suites that share a common living area and two baths.")
        addLocation(building: "Beatty Center", latitude: 32.782807, longitude: -79.935050, description: "Entering into the Beatty Center, home of the School of Business, is like walking into a modern corporate atrium. It feels like a place of work for business students who welcome the challenge. Each 'smart' classroom in the Beatty Center is equipped with technology stations with access to applied learning tools and databases to prepare ready-to-work graduates. The building contains classrooms, faculty offices, and a trading desk - a high tech room where students get hands-on experience while they track the movements of stocks on the New York Stock Exchange and other exchanges.")
        addLocation(building: "Thaddeus Street Jr. Education Center", latitude: 32.787847, longitude: -79.936284, description: "This building contains the Jon Morter Anthropology Lab, Michael Pincus Languages Resource Center and the Volpe Center for Teaching and Learning.")
        addLocation(building: "Sylvia Vlosky Yaschik Jewish Studies Center", latitude: 32.781781, longitude: 79.936083, description: "This building is the center of Jewish activity at the College. Jewish studies program offices, the Jewish Historical Society of South Carolina, a Judaica library, the School of Languages, Cultures, and World Affairs all share space in the Jewish Studies Center.")
        addLocation(building: "President's House", latitude: 32.782244, longitude: -79.936359, description: "This is the oldest building on campus, which was constructed in 1770 as the parsonage of St. Philip's Church. In 1785, Reverend Dr. Robert Smith established a successful academy at 6 Glebe Street and immediately transferred his 60 students to the College when he became the first president of the institution in 1789.")
        addLocation(building: "Fraternity Row", latitude: 32.781056, longitude: -79.937390, description: "Fraternity Row is located between the N.E. Miles Early Childhood Development Center and Glenn McConnell Residence Hall, on the corner of Wentworth and Coming streets.")
        addLocation(building: "Sorority Row", latitude: 32.781359, longitude: -79.937618, description: "Sorority Row is on Coming Street between Wentworth and George Streets. Upperclassmen live in some of the historic houses along Coming Street as well.")
        addLocation(building: "Rita Liddy Hollings Science Center", latitude: 32.783257, longitude: -79.938237, description: "The Rita Hollings Science Center (RITA) underwent a major renovation to modernize its instructional and research capabilities. The first three floors consist of eight classrooms, fifty one research labs, and twenty seven teaching labs, which are all utilized for Biology, Physics, Astronomy, and Psychology. The fourth floor/roof houses the astronomy lab, control room, telescope dome, astronomy deck, and vivarium. The building contains over sixty faculty and staff offices.")
        addLocation(building: "Theodore S. Stern Student Center", latitude: 32.782817, longitude: -79.937631, description: "Built in 1974, the Stern Center has served as the hub of campus life for more than three decades. It features a food court, email-kiosks, ATMs, lockers, a canteen area, a game room, as well as meeting and programming space for student organizations, on-campus departments and off-campus groups. Behind the building is a private garden and a patio.")
        addLocation(building: "Wilson-Sottile House", latitude: 32.784054, longitude: -79.938330, description: "Constructed around 1891 by Samuel Wilson, the house was given to the College of Charleston by the Sottile family in 1964. It was used as a dormitory, but today, it houses the College's Office of Institutional Advancement.")
        addLocation(building: "Honors College", latitude: 32.784264, longitude: -79.937818, description: "Built around 1841, Honors College students gather here to study, work on group projects, and relax in the upstairs lounge/reading room. This house is named for William Aiken, a former South Carolina governor.")
        addLocation(building: "Marlene and Nathan Addlestone Library", latitude: 32.784265, longitude: -79.939664, description: "The Addlestone Library is the region's top research library. This modern, three-story facility has a holding capacity of one million volumes, seats 1,400 people and has 300 computers. It also includes dozens of laptops that can be checked out. This is also the prime study spot on campus. Rivers Green is a large inviting lawn and patio area behind the library that's equipped with tables, chairs, and high-speed WiFi.")
        addLocation(building: "Science and Mathematics Building", latitude: 32.784816, longitude: -79.939783, description: "The new Science and Mathematics Building houses the geology, chemistry and biochemistry departments, Lowcountry Hazards Center, South Carolina Space Grant offices, a NASA Lunar outreach and education office, the Mace Brown Natural History Museum, GIS and remote sensing laboratories and geosciences laboratories.")
        addLocation(building: "Chapel Theatre and Chapel Annex", latitude: 32.785139, longitude: -79.938528, description: "The new Science and Mathematics Building houses the geology, chemistry and biochemistry departments, Lowcountry Hazards Center, South Carolina Space Grant offices, a NASA Lunar outreach and education office, the Mace Brown Natural History Museum, GIS and remote sensing laboratories and geosciences laboratories.")
        addLocation(building: "Joe E. Berry Jr. Residence Hall", latitude: 32.785942, longitude: -79.937751, description: "Berry Residence Hall is a six-story, co-ed building on the corner of Calhoun and St. Phillip's streets. It was constructed in 1988 and then renovated in 2003. Berry Hall features numerous community spaces and laundry rooms on each floor. It is arranged with all suites opening to inside corridors. Each suite consists of 2-3 bedrooms, 1-2 bathrooms, and 1 living room with a kitchenette; suites are shared by 4-6 students. Floors 1-3 are for Honors College students and are by invitation only.")
        addLocation(building: "Marcia Kelly McAlister Residence Hall", latitude: 32.786656, longitude: -79.938297, description: "McAlister Residence Hall is a six-story building, housing approximately 530 students. The building was constructed in 2002, and features community spaces including the 1st floor Activity/Study Room, complete with a communal kitchen, a central courtyard, and 24-hour information/security desk. McAlister Hall is arranged with all suites opening to outside corridors. Each suite consists of 2-3 bedrooms, 2-3 bathrooms, and a living room with kitchenette. All suites are shared by 4-6 students and all bedrooms are shared by two residents. The building has free laundry centrally located on the ground floor. It is also home to Einstein Bros. Bagels.")
        addLocation(building: "Kelly House", latitude: 32.787211, longitude: -79.938683, description: "Kelly House is a four-story apartment complex at the corner of St. Phillip and Vanderhorst Streets. Renovated in 2018, the building features a central courtyard and central laundry room located on the first floor. It is arranged with all apartments opening to the outside corridors. Townhouse apartments are shared by 5 residents and consist of 4 bedrooms, 2 bathrooms, 1 living room and a full kitchen. Kitchens include a stove, microwave, sink and a full-size refrigerator. Single-level apartments are shared by 2-6 residents and consist of 2-3 bedrooms and 1-2 bathrooms.")
        addLocation(building: "Warren Place", latitude: 32.787932, longitude: -79.938731, description: "Warren Place is an apartment complex consisting of three buildings, and each building has a central laundry facility on the first floor and covered bicycle storage in an outside area shared by all buildings. Warren Place is arranged with all apartments opening to inside. Each apartment is fully furnished and consists of 2-5 bedrooms (4-10 students per apartment), 1-2 bathrooms, a full kitchen, as well as a living room. This building has controlled-access entry.")
        addLocation(building: "College of Charleston Bookstore", latitude: 32.785714, longitude: -79.937141, description: "In addition to textbooks, the bookstore sells a wide variety of College of Charleston gifts and apparel, and general-interest books.")
        addLocation(building: "Lightsey Center", latitude: 32.785611, longitude: -79.937177, description: "The registrar's office, financial aid, Career Center and disability services office are located here. The Academic Advising and Planning Center is located on the second floor.")
        addLocation(building: "College Lodge", latitude: 32.785301, longitude: -79.936984, description: "College Lodge is a six-story co-ed building housing approximately 200 students. Residents share a large room with sitting area and internal bathroom. College Lodge features a common game room, a study room, free laundry facilities, a common kitchen, as well as an outside courtyard equipped with a basketball court and cookout area. Located on the first floor, is Market 159 which carries an array of products.")
        addLocation(building: "Cougar Mall", latitude: 32.785061, longitude: -79.938016, description: "One of the main entrances to the campus is through Cougar Mall, which is located diagonally across the street from the Chapel Theatre. The statue of the cougar, the College's mascot, guards the entrance to Cougar Mall, which ends at the fountain behind Randolph Hall. The Latin inscription that appears above the wrought-iron gate marking the entrance to Cougar Mall was taken from Homer's Aeneid and means to 'remember these things will be a pleasure'.")
        addLocation(building: "Albert Simons Center for the Arts", latitude: 32.784517, longitude: -79.936910, description: "The first floor of the Simons Center features the Simons Student Gallery, the Visual Arts Club Student Gallery, as well as the state-of-the-art Printmaking and Sculpture studios. The fourth floor of Simons hosts our Independent Studios for Painting and Drawing, and Advanced Drawing classroom and department offices.")
        addLocation(building: "Marion and Wayland H. Cato Jr. Center for the Arts", latitude: 32.784931, longitude: -79.937138, description: "The CATO Center is our newest art building on campus, having been opened in January 2020. This building houses the Halsey Institute of Contemporary Art and The Hill Exhibition Gallery on the first floor. The fourth floor features two large painting studios, a woodshop for building canvases, and a classroom for our senior exhibition course. The fifth floor is devoted to photography with a massive darkroom for developing film, a state of the art digital photography laboratory and a lighting studio.")
        addLocation(building: "Halsey Institute of Contemporary Art", latitude: 32.784931, longitude: -79.937138, description: "The Halsey Institute of Contemporary Art at the College provides a multidisciplinary laboratory for the production, presentation, interpretation, and dissemination of ideas by innovative visual artists from around the world. As a non-collecting museum, we create meaningful interactions between adventurous artists and diverse communities within a context that emphasizes the historical, social, and cultural importance of the art of our time.")
        addLocation(building: "Harbor Walk", latitude: 32.791499, longitude: -79.926201, description: "The Department of Computer Science officially moved into Harbor Walk East in June of 2014. The new space provides all faculty offices and features four classrooms, flex space, eight research labs, two student work spaces, and a conference room. Less than a mile from campus, courses at Harbor Walk begin at a 30-minute delayed interval from the main campus schedule.")
        addLocation(building: "City Bistro", latitude: 32.785653, longitude: -79.937705, description: "Berry Hall houses City Bistro, one of two residential all-you-care-to-eat dining halls. With 7 stations, this facility offers an upscale rotating menu consisting of items such as delicious seafood, brick-oven baked pizza, and gourmet burgers. There is also a fresh salad bar stocked with an array of local produce as well as a build-your-own sandwich station.")

    }
}
