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
    var firstLocation: CLLocation?
    var monitorBool: Bool? = true
    
    var startLocation: CLLocation? = nil

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.mapView.showsUserLocation = true
        
        if locationManager.location?.horizontalAccuracy < 20 {
            self.locationManager.startUpdatingLocation()
//            let center = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
//            self.mapView.setRegion(region, animated: true)
            restartSearchandMonitor()
        }
        
        print(locationManager.location?.coordinate.latitude)

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartSearchandMonitor", name: "reload", object: nil)
        
    }
    @IBAction func searchButton(sender: AnyObject) {
        //performSearch("Starbucks")
        let actionSheetController: UIAlertController = UIAlertController(title: "Refresh", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let startAction: UIAlertAction = UIAlertAction(title: "Force start monitoring", style: .Default) { action -> Void in
            self.monitorBool = true
            self.restartSearchandMonitor()
            
            
        }
        
        let stopAction: UIAlertAction = UIAlertAction(title: "Force stop monitoring", style: .Destructive) { action -> Void in
            self.stopMonitoring()
            self.monitorBool = false
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //
        }
        actionSheetController.addAction(startAction)
        actionSheetController.addAction(stopAction)
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
    
//    func searchDataAsync(completionHandler:(String)->()){
//        print("start search")
//        self.searchData()
//        print("finished search")
//        completionHandler("RETURN!!")
//    }
//    
//    func restartSearchandMonitor(){
//        if monitorBool == true {
//            if self.regionsToMonitor == [] {
//                self.searchDataAsync() {result in
//                    print(result)
//                    self.startMonitoring()
//                    print("afterMonitor")
//                }
//            }  else {
//                stopMonitoring()
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(4 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
//                    self.restartSearchandMonitor()
//                }
//            }
//            startLocation = nil
//        }
//    }
    
    
    func restartSearchandMonitor(){
        if monitorBool == true {
            if self.regionsToMonitor == [] {
                self.searchData()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                    self.startMonitoring()
                }
            }  else {
                stopMonitoring()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                    self.restartSearchandMonitor()
                }
            }
            startLocation = nil
        }
    }
    


    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let currentLocation: CLLocation = manager.location!
        if startLocation == nil {
            startLocation = currentLocation
        }
        let distance = currentLocation.distanceFromLocation(startLocation!)
//        print(distance)
        if distance > 1500 {
            print(distance)
            restartSearchandMonitor()
        }
        
        let center = CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)


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
//                print("Name = \(item.name)")
//                print("Phone = \(item.phoneNumber)")
//                print(item.placemark.thoroughfare)
//                print(item.placemark.subThoroughfare)
  
            
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
        if location.placemark.subThoroughfare != nil {
            identifier = "\(location.name!), \(location.placemark.thoroughfare!) \(location.placemark.subThoroughfare!)"
        }
        else if location.placemark.thoroughfare != nil {
            identifier = "\(location.name!), \(location.placemark.thoroughfare!)"
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
        print(region)
        print(manager.location)

    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        print("YAY")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton = UIButton(type: .Custom)
            //var rightButton: AnyObject! = UIButton.buttonWithType(UIButtonType.DetailDisclosure)
            //rightButton.titleForState(UIControlState.Normal)
            rightButton.frame.size.width = 44
            rightButton.frame.size.height = 60
            rightButton.backgroundColor = UIColor.lightGrayColor()
            
            pinView!.rightCalloutAccessoryView = rightButton as UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView!
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        showRoute(<#T##response: MKDirectionsResponse##MKDirectionsResponse#>)
    }
    
    func showRoute(response: MKDirectionsResponse) {
        print("showing route")
        for route in response.routes {
            mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                print(step.instructions)
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

