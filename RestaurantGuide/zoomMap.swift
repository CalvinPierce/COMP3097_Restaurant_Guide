//
//  zoomMap.swift
//  RestaurantGuide

//import Foundation
import UIKit
import MapKit
import CoreLocation
class zoomMap: UIViewController {
    

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    
    
    var selectedRestaurant: Restaurant? = nil
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        checkLocationServices()
        
        if(selectedRestaurant != nil){
            address.text = selectedRestaurant?.address
            
            let addr = address.text
            if let loc = addr{
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(loc, completionHandler: {
                                                placemarks, error in
                    
                    if error != nil {print(error!); return}
                    
                    if let placemarks = placemarks {
                        
                        let placemark = placemarks[0]
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = addr
                        //annotation.subtitle = self.folderName
                        
                        if let addr = placemark.location {
                            annotation.coordinate = addr.coordinate
                            
                            self.mapView.showAnnotations([annotation], animated: true)
                            self.mapView.selectAnnotation(annotation, animated: true)
                        }
                    }
                    
                }
            )
                
                mapView.delegate = self
                
                mapView.showsCompass = true
                
                mapView.showsTraffic = true
                
                mapView.showsUserLocation = true
                
                
        }
    }
}

        // Do any additional setup after loading the view.
        
    


    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            locationManagerDidChangeAuthorization(locationManager)
            startTackingUserLocation()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            let authStatus = manager.authorizationStatus
            if authStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                return
            }
        }
    //If you’re using the simulator your location will always be San Francisco California.
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        var latitude = mapView.centerCoordinate.latitude
        var longitude = mapView.centerCoordinate.longitude
        //var latitude: Double = 0
        //var longitude: Double = 0
        if(selectedRestaurant != nil){
            address.text = selectedRestaurant?.address
            let addr = address.text
            if let loc = addr{
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(loc, completionHandler: {
                                                placemarks, error in
                    
                    if error != nil {print(error!); return}
                    
                    if let placemarks = placemarks {
                        
                        let placemark = placemarks[0]
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = addr
                        //annotation.subtitle = self.folderName
                        
                        if let addr = placemark.location {
                            annotation.coordinate = addr.coordinate
                            latitude = annotation.coordinate.latitude
                            longitude = annotation.coordinate.longitude
                            
                            
                            //self.mapView.showAnnotations([annotation], animated: true)
                            //self.mapView.selectAnnotation(annotation, animated: true)
                        }
                    }
                    
                }
            )
        }
    }
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
  }
    
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        //resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        getDirections()
    }
}

extension zoomMap: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(locationManager)
    }
}

extension zoomMap: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 500 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.address.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        
        return renderer
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            print(#function)
            
            let pinIdentifier = "MyPin"
            if annotation.isKind(of: MKUserLocation.self) { return nil} // verify the annotation object is kin of user location. If yes, display user location as a default blue dot
            
            // reuse annotation if possible for performance efficieny
            var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView  // reuse then downcast
            
            if annotationView == nil {  // no unused views available
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier) // create new view
                annotationView?.canShowCallout = true // instantiate the standard red pin callout buble
            }
            
            return annotationView
            
        }
}
