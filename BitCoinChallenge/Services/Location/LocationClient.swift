//
//  LocationClient.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/// Handles the location data updates for any interested enitity.
class LocationClient: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        
        let lat = String(location.coordinate.latitude)
        let lon = String(location.coordinate.longitude)

        NotificationCenter.default.post(name: NSNotification.Name.LatLon, object: nil, userInfo: ["lat": lat, "lon" : lon])
        }
}

extension NSNotification.Name {
    static let LatLon = NSNotification.Name("LatLon")
}


