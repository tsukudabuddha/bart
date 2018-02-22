//
//  ClosestStationViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/21/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ClosestStationViewController: TimeTableViewController {
    
    var locationManager: CLLocationManager!
    var allStations: [Station] = []
    var closestStation: Station? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        /* Check to see if this already has a station -- from list */
        if let chosenStation = super.chosenStation {
            super.getTimeTable()
            super.stationLabel.text = chosenStation.name
        } else { // if no station passed in-- then find closest station and set
            /* Get all stations */
            Network().getStations { (allStations) in
                self.allStations = allStations
                self.closestStation = allStations[0]
                
                /* Find user's location after getting station list */
                self.determineMyCurrentLocation() // In extension at bottom of file
            }
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        super.viewWillAppear(animated) // Start Refresh timer
    }
}

extension ClosestStationViewController: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()

        for station in self.allStations {
            if userLocation.distance(from: station.location) < userLocation.distance(from: (self.closestStation?.location)!) {
                self.closestStation = station
            }
        }
        
        /* Found Closest Station */
        stationLabel.text = self.closestStation?.name ?? "Still Searching"
        super.chosenStation = self.closestStation
        super.getTimeTable()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
