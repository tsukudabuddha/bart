//
//  Network.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/8/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    
    func getStations() { //}-> [Station] {
        let stationsUrlString = "https://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V&json=y"
        if let stationURL = URL(string: stationsUrlString) { // Safely Unwrap URL
            
            Alamofire.request(stationURL, method: .get).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    do {
                        let stationContainer = try JSONDecoder().decode(StationContainer.self, from: data)
                        let stations = stationContainer.stations
                        print(stations)
                    } catch {
                        print("No work")
                    }
                }
            })
        }
        
    }
}
