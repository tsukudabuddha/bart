//
//  ClosestStationViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/9/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//
// Most of the CLLocation was found on apple documentation and the link below
// http://swiftdeveloperblog.com/code-examples/determine-users-current-location-example-in-swift/

import UIKit
import CoreLocation

class ClosestStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locationManager: CLLocationManager!
    var allStations: [Station] = []
    var closestStation: Station? = nil
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var timeTable: TimeTable? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Get all stations */
        Network().getStations { (allStations) in
            self.allStations = allStations
            self.closestStation = allStations[0]
            
            /* Find user's location after getting staion list */
            self.determineMyCurrentLocation() // In extension at bottom of file
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell", for: indexPath) as! TimeTableTableViewCell
        if let timeTable = self.timeTable {
            let timeTableEntry = timeTable.etd[indexPath.row]
            cell.destinationLabel.text = timeTableEntry.destination
            if let minutesToLeave = Int(timeTableEntry.estimates[0].minutes) {
                cell.closestTrainTimeLabel.text = "\(minutesToLeave) min"
            } else {
                cell.closestTrainTimeLabel.text = "Leaving"
            }
            cell.otherTrainEstimatesLabel.text = "\(timeTableEntry.nextTimesString) min"
            cell.trainColorView.backgroundColor = UIColor(hex: timeTableEntry.estimates[0].hexColor)
            cell.platformLabel.text = "Platform \(timeTableEntry.estimates[0].platform)"
            
            /* Create white border around each cell */
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.borderWidth = 0.5
            
            /* Make Each Cell °•°° */
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* Return the number of tte if there is a time table-- default to 0 if not found */
        return self.timeTable?.etd.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        for station in self.allStations {
            if userLocation.distance(from: station.location) < userLocation.distance(from: (self.closestStation?.location)!) {
                self.closestStation = station
            }
        }
        
        /* Found Closest Station */
        stationLabel.text = self.closestStation?.name ?? "Still Searching"
        Network().getTimeTable(abbreviation: self.closestStation?.abbreviation ?? "12th") { (timeTable) in
            
            /* Create new mutable variable to sort before tableview decides order */
            var sortedTimeTable = timeTable
            sortedTimeTable.etd.sort()
            
            self.timeTable = sortedTimeTable
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
