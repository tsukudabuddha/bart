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

class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refreshTimer: Timer! // auto refresh times every 45 sec-- starts in view will appear
    var chosenStation: Station? = nil
    var showbackButton: Bool = false
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
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
        
        if self.showbackButton {
            backButton.isHidden = false
            backButton.isEnabled = true

        } else {
            backButton.isHidden = true
            backButton.isEnabled = false
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        popController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Start Refresh Timer */
        refreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(getTimeTable), userInfo: nil, repeats: true)
        
    }
    
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /* Stop refresh timer */
        self.refreshTimer.invalidate() // view refreshes in view will appear and restarts timer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Get access to cell */
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell", for: indexPath) as! TimeTableTableViewCell
        
        /* Safely unwrap timetable in order to configure cell */
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
    
    @objc func getTimeTable() {
        Network().getTimeTable(abbreviation: self.chosenStation?.abbreviation ?? "12th") { (timeTable) in
            
            /* Create new mutable variable to sort before tableview decides order */
            var sortedTimeTable = timeTable
            sortedTimeTable.etd.sort()
            
            self.timeTable = sortedTimeTable
        }
    }

}
