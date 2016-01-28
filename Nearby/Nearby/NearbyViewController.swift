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
        
        /* init for locationManager and Mapview */
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        /* setting the accuracy and authorization for tracking the users location at all times */
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        /* start opdating the location, shows a blue dot on the map and zooms in on the blue dot/follows it around */
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
        
        /* wait for the user accuracy for doing an extra wait for inzooming on the map.  */
        /*This is because MKLocalSearch uses the view region. */
        /* when its not fully zoomed in it will take a to large region to search in */
        if locationManager.location?.horizontalAccuracy < 20 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.restartSearchandMonitor()
            }
        }
        /* defining a notification  for the restartSearchandMonitor main function, */
        /* used when adding and deleting objects in the tableviews */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartSearchandMonitor", name: "reload", object: nil)
    
    }
    /* main function to restart the search and monitor, there is a dispatch_after because the monitor will have to wait for the search */
    func restartSearchandMonitor(){
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
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
            /* startLocation will be set to nil, a new distance will be calculated from a new start point */
            startLocation = nil
        }
    }
    
    /* forcing to start or stop monitoring, bool is for prefenting the application to start from elsewhere in the app */
    @IBAction func searchButton(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Refresh", message: "", preferredStyle: .ActionSheet)
        
        let startAction: UIAlertAction = UIAlertAction(title: "Force start monitoring", style: .Default) { action -> Void in
            self.monitorBool = true
            self.restartSearchandMonitor()
        }
        let stopAction: UIAlertAction = UIAlertAction(title: "Force stop monitoring", style: .Destructive) { action -> Void in
            self.stopMonitoring()
            self.monitorBool = false
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //canceled
        }
        actionSheetController.addAction(startAction)
        actionSheetController.addAction(stopAction)
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    /* LocationManager delegete to handle the location updates, calculates the distance from the start */
    /* sets a new startLocation and restarts the app if the boundary is crossed */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = manager.location!
        if startLocation == nil {
            startLocation = currentLocation
        }
        
        let distance = currentLocation.distanceFromLocation(startLocation!)
        if distance > 1500 {
            restartSearchandMonitor()
        }
    }
    
    /* search for data in the NSUserdefaults (favorites) if its empty, Alert the user */
    func searchData() {
        if self.defaults.stringArrayForKey("favoriteKey") != nil {
            storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
            for item in storedFavorites! {
                performSearch(item)
            }
        } else {
            stopMonitoring()
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "You have no Favorites!", preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok!", style: .Cancel) { action -> Void in
                //cancelled
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    /* function for the MLLocalsearch, takes a natural language string does the search and puts a annotation on the map */
    func performSearch(input: String) {
        print("searching")

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = input
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        
        /* since its does multiple searches, it should wait for the previous to finnish, hence the completionhandler */
        search.startWithCompletionHandler { response,
            error in guard let response = response else {
                print("error")
                return
            }
            print("Matches found")
            
            for item in response.mapItems {
//                print("Name = \(item.name) \(item.placemark.thoroughfare)")
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
    
    /* transform the MapItems found in the search into a ClRegion to be ready for monitoring */
    /* locations need an unique identifier to get their own region, using adress for this */
    func makeRegions(location: MKMapItem) -> CLRegion {
        var identifier: String
        let latitude: CLLocationDegrees = location.placemark.location!.coordinate.latitude
        let longitude: CLLocationDegrees = location.placemark.location!.coordinate.longitude
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(200.0)
        if location.placemark.subThoroughfare != nil {
            identifier = "\(location.name!), \(location.placemark.thoroughfare!) \(location.placemark.subThoroughfare!)"
        } else if location.placemark.thoroughfare != nil {
            identifier = "\(location.name!), \(location.placemark.thoroughfare!)"
        } else {
            identifier = "\(location.name!)"
        }
        let geoRegion: CLCircularRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        
        return geoRegion
    }
    
    /* Main function for making the regions from mapitems and appending them to a list to loop and monitor individualy */
    func startMonitoring(){
        for item in matchingItems {
            regionsToMonitor.append(makeRegions(item))
        }
        for item in regionsToMonitor {
            locationManager.startMonitoringForRegion(item)
        }
    }
    
    /* handles the stop for minotoring regions empties lists and removes all annotations related to the monitored regions */
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
    
    /* Making custom annotations for the user to see, adding a button to interact and launch Apple Maps */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        /* prevents the users location from being an annotation */
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton = UIButton(type: .Custom)
            rightButton.frame.size.width = 44
            rightButton.frame.size.height = 60
            rightButton.backgroundColor = UIColor.lightGrayColor()
            rightButton.setImage(UIImage(named: "walking-1.png"), forState: .Normal)

            pinView!.rightCalloutAccessoryView = rightButton as UIView
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView!
    }
    
    /* button on annotation action function, launching the Apple Maps app with the needed information */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            /* get the selected annotation */
            let selectedLoc = view.annotation
            
            /* get the users current location */
            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation()
            
            /* make a MapItem of the annotation */
            let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
            
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            selectedMapItem.name = (selectedLoc?.title)!
            
            let mapItems = [selectedMapItem, currentLocMapItem]
            
            /* Launch Apple Maps with walking route */
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            
            MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
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

