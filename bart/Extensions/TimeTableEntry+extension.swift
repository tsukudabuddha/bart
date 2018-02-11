//
//  TimeTableEntry+extension.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/10/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation

extension TimeTableEntry: Comparable {
    static func <(lhs: TimeTableEntry, rhs: TimeTableEntry) -> Bool {
        var returnBool = true
        if let leftMinutes = Int(lhs.estimates[0].minutes) {
            if let rightMinutes = Int(rhs.estimates[0].minutes) {
                returnBool = leftMinutes < rightMinutes
            } else {
                returnBool = false
            }
        } else {
            returnBool = true
        }
        return returnBool
    }
    
    static func ==(lhs: TimeTableEntry, rhs: TimeTableEntry) -> Bool {
        return lhs.estimates[0].minutes < rhs.estimates[0].minutes
    }
    
    
}
