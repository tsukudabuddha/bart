//
//  AllStationListTableViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/8/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//
//

// Thanks to Hacking with swift for userdefaults help
// https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults

import UIKit

class AllStationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var stations = [Station]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Make sure station list is up to date */
        updateStations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /* Check if the table is empty */
        if stations.count == 0 {
            updateStations()
        }
        let backgroundImage = UIImage(named: "Background")
        let backgroundView = UIImageView(image: backgroundImage!)
        self.tableView.backgroundView = backgroundView
    }
    
    func updateStations() {
        Network().getStations { (apiStations) in
            self.stations = apiStations
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.stations.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = stations[indexPath.row].name
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenStation = stations[indexPath.row]
        let timeTableVC = storyboard?.instantiateViewController(withIdentifier: "timeTableVC") as! TimeTableViewController
        timeTableVC.chosenStation = chosenStation
        timeTableVC.showbackButton = true
        
        /* Un-hilight row*/
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        /* Display time table vc for row */
        self.navigationController?.pushViewController(timeTableVC, animated: true)
       
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let favoriteAction = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            // Add favorite action -- userdefaults
            let defaults = UserDefaults.standard
            var favStations: [Station] = []
            
            let decoder = JSONDecoder()
            if let favoritesData = defaults.data(forKey: "favoritesArray"),
                let stations = try? decoder.decode([Station].self, from: favoritesData) {
                favStations = stations
            }
            var canAdd = true
            
            let selectedStation = self.stations[editActionsForRowAt.row]
            for station in favStations {
                if station.abbreviation == selectedStation.abbreviation {
                    canAdd = false
                }
            }
            
            /* If the station isn't already in list, add to list */
            if canAdd {
                favStations.append(selectedStation)
                favStations.sort() // Store in sorted order
                let encoder = JSONEncoder()
                if let favoriteStations = try? encoder.encode(favStations) {
                    UserDefaults.standard.set(favoriteStations, forKey: "favoritesArray")
                }
            }
            
        }
        favoriteAction.backgroundColor = .blue
        return [favoriteAction]
    }

}
