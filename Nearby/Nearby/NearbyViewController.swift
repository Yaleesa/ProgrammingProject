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
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var locationManager = CLLocationManager()
    var annotationsList: [MKAnnotation] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        if locationManager.location?.horizontalAccuracy < 20 {
            self.locationManager.startUpdatingLocation()
            restartSearchandMonitor()
        }
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopMonitoring", name: "reload", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartSearchandMonitor", name: "reload", object: nil)
        
    }
    @IBAction func searchButton(sender: AnyObject) {
        //performSearch("Starbucks")
        let actionSheetController: UIAlertController = UIAlertController(title: "Refresh", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let startAction: UIAlertAction = UIAlertAction(title: "Force start monitoring", style: .Default) { action -> Void in
            self.restartSearchandMonitor()
            
        }
        
        let stopAction: UIAlertAction = UIAlertAction(title: "Force stop monitoring", style: .Destructive) { action -> Void in
            self.stopMonitoring()
        }
        actionSheetController.addAction(startAction)
        actionSheetController.addAction(stopAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
    func restartSearchandMonitor(){
        if self.regionsToMonitor == [] {
            self.searchData()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.startMonitoring()
            }
        }  else {
            stopMonitoring()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.restartSearchandMonitor()
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func searchData() {
        
        if self.defaults.stringArrayForKey("favoriteKey") != nil {
            storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
            
            for item in storedFavorites! {
                performSearch(item)
    
            }
  
        }else{
            print("geen items")
            stopMonitoring()
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
                if item.placemark.thoroughfare != nil {
                    annotation.title = "\(item.name!), \(item.placemark.thoroughfare!)"
                } else {
                    annotation.title = item.name
                }
                self.mapView.addAnnotation(annotation)
                self.annotationsList.append(annotation)
    
            }
        }
    }
    
    func makeRegions(location: MKMapItem) -> CLRegion {
        var identifier: String
        let latitude: CLLocationDegrees = location.placemark.location!.coordinate.latitude
        let longitude: CLLocationDegrees = location.placemark.location!.coordinate.longitude
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(200.0)
        if location.placemark.thoroughfare != nil {
            identifier = "\(location.name!), \(location.placemark.thoroughfare!) \(location.placemark.subThoroughfare!)"
        } else {
            identifier = "\(location.name!)"
        }

        
        let geoRegion: CLCircularRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        
        return geoRegion
        
    }
    
    func startMonitoring(){

        locationManager.requestAlwaysAuthorization()
        
        for item in matchingItems {
            regionsToMonitor.append(makeRegions(item))

        }
        
        for item in regionsToMonitor {
            locationManager.startMonitoringForRegion(item)
        }
        

    }

    
    func stopMonitoring() {
        print("stopped monitoring")
        matchingItems.removeAll()
        regionsToMonitor.removeAll()
        
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )

        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                locationManager.stopMonitoringForRegion(circularRegion)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering region")

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

