//
//  AllStationListTableViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/8/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class AllStationListTableViewController: UITableViewController {
    
    var stations = [Station]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        let network = Network()
        network.getStations { (apiStations) in
            self.stations = apiStations
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "Background")
        let backgroundView = UIImageView(image: backgroundImage!)
        self.tableView.backgroundView = backgroundView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.stations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StationTableViewCell

        // Configure the cell...
        cell.nameLabel.text = stations[indexPath.row].name

        // Make Each Cell °•°°
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenStation = stations[indexPath.row]
        let timeTableVC = storyboard?.instantiateViewController(withIdentifier: "timeTableVC") as! TimeTableViewController
        timeTableVC.chosenStation = chosenStation
        timeTableVC.showbackButton = true
        
        /* Un-hilight row */
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(timeTableVC as! TimeTableViewController, animated: true)
       
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let favoriteAction = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            // TODO: Add favorite action -- userdefaults
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
