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
    
    func getStations(completion: @escaping ([Station]) -> ()) {
        let stationsUrlString = "https://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V&json=y"
        if let stationURL = URL(string: stationsUrlString) { // Safely Unwrap URL
            
            Alamofire.request(stationURL, method: .get).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    let stationContainer = try? JSONDecoder().decode(StationContainer.self, from: data)
                    if let stationContainer = stationContainer {
                        completion(stationContainer.stations)
                    }
                    
                }
            })
        }
        
    }
    
    func getTimeTable(abbreviation: String, completion: @escaping (TimeTable) -> ()) {
        let queryString = "https://api.bart.gov/api/etd.aspx?cmd=etd&orig=\(abbreviation.lowercased())&key=MW9S-E7SL-26DU-VV8V&json=y"
        
        if let queryUrl = URL(string: queryString) {
            
            Alamofire.request(queryUrl, method: .get).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    let ttContainer = try? JSONDecoder().decode(TimeTableContainer.self, from: data)
                    if let timetable = ttContainer?.stationTimeTables[0] {
                        completion(timetable)
                    }
                }
            })
            
        }
    }
}
