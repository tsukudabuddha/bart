//
//  DirectionsViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/11/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var trip: Trip? = nil
    var allStations: [Station]? = nil
    var stationDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Create Station Dictionary */
        if let allStations = self.allStations {
            for station in allStations {
                stationDict[station.abbreviation] = station.name
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trip?.legs.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directionsCell") as! DirectionsTableViewCell
        if let leg = trip?.legs[indexPath.row] {
            cell.originStationLabel.text = stationDict[leg.origin]
            cell.originTime.text = leg.originTime
            cell.destinationStationLabel.text = stationDict[leg.destination]
            cell.destinationTimeLabel.text = leg.destinationTime
            cell.headTrainLabel.text = "\(stationDict[leg.trainHeadStation]) train"
        }
        
        return cell
    }

}
