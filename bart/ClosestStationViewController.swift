//
//  ClosestStationViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/9/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class ClosestStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        Network().getTimeTable { (timeTable) in
            
            /* Create new mutable variable to sort before tableview decides order */
            var sortedTimeTable = timeTable
            sortedTimeTable.etd.sort()
            
            self.timeTable = sortedTimeTable
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Make tableview transparent */
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
            
            cell.platformLabel.text = "Platform \(timeTableEntry.estimates[0].platform)"
            
            /* Create white border around each cell */
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.borderWidth = 0.5
            
            /* Make Each Cell transparent */
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows = 0
        if let timeTable = self.timeTable {
            rows = timeTable.etd.count
        }
        return rows
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
