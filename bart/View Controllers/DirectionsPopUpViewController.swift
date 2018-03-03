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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stationNames: [String] = []
        // Do any additional setup after loading the view.
        Network().getStations { (stationArray) in
            stationNames = stationArray.map {station in station.name}
            self.fromTextField.filterStrings(stationNames)
            self.toTextField.filterStrings(stationNames)
        }
        
    }

    @IBAction func goPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
//        self.pop
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
