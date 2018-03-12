//
//  Directions.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/6/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation


struct Trip {
    let fare: String
    let departingTime: String
    let arrivalTime: String
    let legs: [Leg]
    let travelTime: String
}

extension Trip: Decodable {
    enum CodingKeys: String, CodingKey {
        case fare = "@fare"
        case departingTime = "@origTimeMin"
        case arrivalTime = "@destTimeMin"
        case legs = "leg" // Array of legs
        case travelTime = "@tripTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fare = try container.decode(String.self, forKey: .fare)
        departingTime = try container.decode(String.self, forKey: .departingTime)
        legs = try container.decode([Leg].self, forKey: .legs)
        arrivalTime = legs[legs.count - 1].destinationTime
        travelTime = try container.decode(String.self, forKey: .travelTime)
    }
}


struct DirectionsContainer {
    let trips: [Trip] // its only one though
}

extension DirectionsContainer: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case root
    }
    
    enum RootKeys: String, CodingKey {
        case schedule
    }
    
    enum ScheduleKeys: String, CodingKey {
        case request
    }
    
    enum RequestKeys: String, CodingKey {
        case trip
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rootContainer = try container.nestedContainer(keyedBy: RootKeys.self, forKey: .root)
        let scheduleContainer = try rootContainer.nestedContainer(keyedBy: ScheduleKeys.self, forKey: .schedule)
        let requestContainer = try scheduleContainer.nestedContainer(keyedBy: RequestKeys.self, forKey: .request)
        trips = try requestContainer.decode([Trip].self, forKey: .trip)
        
    }
    
    
}


struct Leg: Decodable {
    let order: String
    let origin: String
    let originTime: String
    let destination: String
    let destinationTime: String
    let trainHeadStation: String
    let bike: String
    
    enum CodingKeys: String, CodingKey {
        case order = "@order"
        case origin = "@origin"
        case originTime = "@origTimeMin"
        case destination = "@destination"
        case destinationTime = "@destTimeMin"
        case trainHeadStation = "@trainHeadStation"
        case bike = "@bikeflag"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decode(String.self, forKey: .order)
        origin = try container.decode(String.self, forKey: .origin)
        originTime = try container.decode(String.self, forKey: .originTime)
        destination = try container.decode(String.self, forKey: .destination)
        destinationTime = try container.decode(String.self, forKey: .destinationTime)
        trainHeadStation = try container.decode(String.self, forKey: .trainHeadStation)
        bike = try container.decode(String.self, forKey: .bike)
        
    }
}
