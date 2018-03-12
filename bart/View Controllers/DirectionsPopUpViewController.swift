//
//  DirectionsPopUpViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/2/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

protocol directionsDelegate {
    func showDirections(controller: DirectionsPageViewController)
}

class DirectionsPopUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fromTextField: SearchTextField!
    
    @IBOutlet weak var toTextField: SearchTextField!
    
    var currentStationName: String? = nil
    
    var allStations: [Station]? = nil
    var delegate: directionsDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stationNames: [String] = []
        // Do any additional setup after loading the view.
        
        if let name = currentStationName {
            fromTextField.text = name
        }
        
        /* Set Delegates of text fields */
        fromTextField.delegate = self
        toTextField.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
        
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
    
    /* UIText FIeld Delegate Func */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        goPressed(self)
        return true
    }
    
    @objc func hideKeyboard() {
        fromTextField.resignFirstResponder()
        toTextField.resignFirstResponder()
    }

    @IBAction func goPressed(_ sender: Any) {
        let fromStation = allStations?.filter {station in station.name == fromTextField.text}
        let toStation = allStations?.filter {station in station.name == toTextField.text}
        
        if let from = fromStation, let to = toStation {
            if from.count > 0 && to.count > 0 {
                let fAbb = from[0].abbreviation
                let tAbb = to[0].abbreviation
                
                let network = Network()
                network.getDirections(tAbb: tAbb, fAbb: fAbb, completion: { (directions) in
                    let directionsPageVC = self.storyboard?.instantiateViewController(withIdentifier: "directionsPageVC") as! DirectionsPageViewController
                    directionsPageVC.trips = directions
                    self.delegate?.showDirections(controller: directionsPageVC)
                    self.dismiss(animated: true)
                })
            } else {
                // TODO: Show red text telling user
                print("Wrong station names")
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
