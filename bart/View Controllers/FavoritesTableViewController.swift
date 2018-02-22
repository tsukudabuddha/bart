//
//  FavoritesTableViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/21/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    var stations: [Station]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.stations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = stations![indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        
        // Make Each Cell °•°°
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
