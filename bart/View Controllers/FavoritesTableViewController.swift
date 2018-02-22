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
    
    var stations: [FavoriteStation]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set up background */
        let backgroundImage = UIImage(named: "Background")
        let backgroundView = UIImageView(image: backgroundImage!)
        self.tableView.backgroundView = backgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Get favorites from core data */
        fetchFavorites()
    }

    
    func fetchFavorites() {
        let stack = CoreDataStack.instance
        let fetchRequest = NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
        do {
            self.stations = []
            let results = try stack.viewContext.fetch(fetchRequest)
            for result in results {
                if let favorites = result.favorites {
                    for fav in favorites {
                        self.stations?.append(fav)
                    }
                }
            }
//            self.stations
            self.tableView.reloadData()
            
        } catch let error {
            print("error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = stations![indexPath.row].name
        
        // Make Each Cell °•°°
        cell.backgroundColor = UIColor.clear

        return cell
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
