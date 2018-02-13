//
//  Station.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/8/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation
import CoreLocation

struct Station {
    let name: String
    let abbreviation: String
    let latitude: String
    let longitude: String
    let address: String
    let city: String
    let county: String
    let state: String
    let zipcode: String
    let location: CLLocation
    var distanceFromUser: CLLocationDistance? = nil
}

extension Station: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case abbreviation = "abbr"
        case latitude = "gtfs_latitude"
        case longitude = "gtfs_longitude"
        case address
        case city
        case county
        case state
        case zipcode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        abbreviation = try container.decode(String.self, forKey: .abbreviation)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        county = try container.decode(String.self, forKey: .county)
        state = try container.decode(String.self, forKey: .state)
        zipcode = try container.decode(String.self, forKey: .zipcode)
        location = CLLocation(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
    }
}

struct StationContainer {
    let stations: [Station]
    
}

extension StationContainer: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case root
    }
    
    enum RootKeys: String, CodingKey {
        case stations
    }
    
    enum StationsKeys: String, CodingKey {
        case station
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rootContainer = try container.nestedContainer(keyedBy: RootKeys.self, forKey: .root)
        let stationsContainer = try rootContainer.nestedContainer(keyedBy: StationsKeys.self, forKey: .stations)
        stations = try stationsContainer.decode([Station].self, forKey: .station)
        
    }
}
