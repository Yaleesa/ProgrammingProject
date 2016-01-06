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
    }
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

