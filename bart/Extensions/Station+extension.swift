//
//  Station+extension.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/21/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import Foundation


extension Station: Comparable {
    static func <(lhs: Station, rhs: Station) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Station, rhs: Station) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
