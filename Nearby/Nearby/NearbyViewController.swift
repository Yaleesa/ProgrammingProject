//
//  ViewController.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 06/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftLocation

class NearbyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkLocationAuthorizationStatus()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

        //self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
        
        
    }
    @IBAction func searchButton(sender: AnyObject) {
        performSearch()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
    func performSearch() {
        print("searching")
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Starbucks"
        request.region = mapView.region

        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response,
            error in guard let response = response else {
                print("error")
                return
                
            }
            print("Matches found")
            
            for item in response.mapItems {
                print("Name = \(item.name)")
                print("Phone = \(item.phoneNumber)")
                
                self.matchingItems.append(item as MKMapItem)
                print("Matching items = \(self.matchingItems.count)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

