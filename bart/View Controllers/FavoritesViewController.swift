//
//  FavoritesTableViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/21/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stations: [Station]? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        /* Set up background */
        let backgroundImage = UIImage(named: "Background")
        let backgroundView = UIImageView(image: backgroundImage!)
        self.tableView.backgroundView = backgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Get favorites from User Defaults */
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let favoritesData = defaults.data(forKey: "favoritesArray"),
            let stations = try? decoder.decode([Station].self, from: favoritesData) {
            self.stations = stations
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.stations?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = stations![indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        
        // Make Each Cell °•°°
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            self.stations?.remove(at: index.row)

            let encoder = JSONEncoder()
            if let favoriteStations = try? encoder.encode(self.stations) {
                UserDefaults.standard.set(favoriteStations, forKey: "favoritesArray")
            }
            self.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenStation = stations![indexPath.row]
        let timeTableVC = storyboard?.instantiateViewController(withIdentifier: "timeTableVC") as! TimeTableViewController
        timeTableVC.chosenStation = chosenStation
        timeTableVC.showbackButton = true
        
        /* Un-hilight row */
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(timeTableVC, animated: true)
        
    }

}
