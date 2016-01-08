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

class NearbyViewController: UIViewController {

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
//    var searchController:UISearchController!
//    var annotation:MKAnnotation!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
//    var error:NSError!
//    var pointAnnotation:MKPointAnnotation!
//    var pinAnnotationView:MKPinAnnotationView!
//
//    
//    @IBAction func showSearchBar(sender: AnyObject) {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.searchBar.delegate = self
//        presentViewController(searchController, animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try SwiftLocation.shared.currentLocation(Accuracy.Room, timeout: 20, onSuccess: { (location) -> Void in
                // location is a CLPlacemark
                print("1. Location found \(location!.description)")
                }) { (error) -> Void in
                    print("1. Something went wrong -> \(error?.localizedDescription)")
            }
        } catch (let error) {
            print("Error \(error)")
        }

        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
        
    }
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
//            let userLocation = mapView.userLocation
//            
//            let region = MKCoordinateRegionMakeWithDistance(
//                userLocation.location!.coordinate, 2000, 2000)
//            
//            mapView.setRegion(region, animated: true)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

