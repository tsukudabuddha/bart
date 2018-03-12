//
//  DirectionsPopUpViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/2/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class DirectionsPopUpViewController: UIViewController {

    @IBOutlet weak var fromTextField: SearchTextField!
    
    @IBOutlet weak var toTextField: SearchTextField!
    
    var currentStationName: String? = nil
    
    var allStations: [Station]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stationNames: [String] = []
        // Do any additional setup after loading the view.
        
        if let name = currentStationName {
            fromTextField.text = name
        }
        
        if let allStations = self.allStations {
            stationNames = allStations.map {station in station.name }
            self.fromTextField.filterStrings(stationNames)
            self.toTextField.filterStrings(stationNames)
        } else {
            Network().getStations { (stationArray) in
                stationNames = stationArray.map {station in station.name}
                self.fromTextField.filterStrings(stationNames)
                self.toTextField.filterStrings(stationNames)
            }
        }
        
        
    }

    @IBAction func goPressed(_ sender: Any) {
        let fromStation = allStations?.filter {station in station.name == fromTextField.text}
        let toStation = allStations?.filter {station in station.name == toTextField.text}
        
        if let from = fromStation, let to = toStation {
            let fAbb = from[0].abbreviation
            let tAbb = to[0].abbreviation
            
            let network = Network()
            network.getDirections(tAbb: tAbb, fAbb: fAbb, completion: { (directions) in
                print(directions)
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
