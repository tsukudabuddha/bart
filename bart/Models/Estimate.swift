//
//  Estimate.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/10/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation

struct TimeTableEntry {
    let destination: String
    let estimates: [TrainEstimate]
    var nextTimes: [String] = []
    
}

extension TimeTableEntry: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case destination
        case estimates = "estimate"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        destination = try container.decode(String.self, forKey: .destination)
        estimates = try container.decode([TrainEstimate].self, forKey: .estimates)
        nextTimes = estimates.map {estimate in estimate.minutes}
        print("nextTimes: \(nextTimes)")
    }
}


struct TrainEstimate {
    let minutes: String
    let platform: String
    let direction: String
    let length: String
    let color: String
    let hexColor: String
    let bike: String
    let delay: String
}

extension TrainEstimate: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case minutes
        case platform
        case direction
        case length
        case color
        case hexColor = "hexcolor"
        case bikeflag
        case delay
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        minutes =  try container.decode(String.self, forKey: .minutes)
        platform = try container.decode(String.self, forKey: .platform)
        direction = try container.decode(String.self, forKey: .direction)
        length = try container.decode(String.self, forKey: .length)
        color = try container.decode(String.self, forKey: .color)
        hexColor = try container.decode(String.self, forKey: .hexColor)
        bike = try container.decode(String.self, forKey: .bikeflag)
        delay = try container.decode(String.self, forKey: .delay)
    }
}

struct TimeTableContainer {
    let stationTimeTables: [TimeTable] // its only one though
}

extension TimeTableContainer: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case root
    }
    
    enum RootKeys: String, CodingKey {
        case station
    }
    
    enum StationsKeys: String, CodingKey {
        case station
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rootContainer = try container.nestedContainer(keyedBy: RootKeys.self, forKey: .root)
        stationTimeTables = try rootContainer.decode([TimeTable].self, forKey: .station)
    }

    
}

struct TimeTable {
    let origin: String
    var etd: [TimeTableEntry]
}

extension TimeTable: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case etd
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        origin = try container.decode(String.self, forKey: .name)
        etd = try container.decode([TimeTableEntry].self, forKey: .etd)
        
    }
}
