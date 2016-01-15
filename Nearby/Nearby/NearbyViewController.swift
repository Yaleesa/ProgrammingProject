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


class NearbyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var storedFavorites: [String]?

    
    var regionsToMonitor: [CLRegion] = []

    @IBOutlet weak var mapView: MKMapView!
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

        
    }
    @IBAction func searchButton(sender: AnyObject) {
        //performSearch("Starbucks")
        matchingItems.removeAll()
        regionsToMonitor.removeAll()
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        searchData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func searchData() {
        
        if self.defaults.stringArrayForKey("favoriteKey")! != []{
            storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
            print(storedFavorites)
            
            for item in storedFavorites! {
                print(item)
                performSearch(item)
                
                
            }
        }else{
            print("geen items")
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "You have no Favorites!", preferredStyle: .ActionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok!", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    
    func performSearch(input: String) {
        print("searching")
        
        
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = input
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
                //self.startMonitoring(item)

                
            }
        }
    }
    
    func makeRegions(location: MKMapItem) -> CLRegion {
        let latitude: CLLocationDegrees = location.placemark.location!.coordinate.latitude
        let longitude: CLLocationDegrees = location.placemark.location!.coordinate.longitude
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(200.0)
        let identifier:String = location.name!
        
        let geoRegion: CLCircularRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        
        //geoRegion.notifyOnEntry = (location.eventType == .OnEntry)
        //geoRegion.notifyOnExit = !geoRegion.notifyOnEntry
        
        return geoRegion
        
    }
    
    func startMonitoring(){
        locationManager.requestAlwaysAuthorization()
        
        for item in matchingItems {
            regionsToMonitor.append(makeRegions(item))

        }
        
        for item in regionsToMonitor {
            print("ITEM TO MONITOR \(item)")
            locationManager.startMonitoringForRegion(item)
        }
        

    }
    @IBAction func monitor(sender: AnyObject) {
        
//        
//        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 52.354453, longitude: 4.955359), radius: 200, identifier: "Home")
//        locationManager.startMonitoringForRegion(currRegion)
            //var item1 = testitems[0]
            //print(item1)
        startMonitoring()
        print(regionsToMonitor.count)
        print(locationManager.monitoredRegions)
        }
        
    
    @IBAction func stop(sender: AnyObject) {
        stopMonitoring()
    }
    
    func stopMonitoring() {
        print("stopped monitoring")
        print(locationManager.monitoredRegions)
        for region in locationManager.monitoredRegions {
            //print(region)
            if let circularRegion = region as? CLCircularRegion {
                locationManager.stopMonitoringForRegion(circularRegion)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering region")
        print(region.description)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

