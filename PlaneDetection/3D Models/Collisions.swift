//
//  Collisions.swift
//  PlaneDetection
//
//  Created by Eduardo on 27/10/18.
//  Copyright © 2018 Alvaro Royo. All rights reserved.
//

import Foundation

struct Collisions: OptionSet{
    let rawValue: Int
    
    static let plane = Collisions(rawValue: 1 << 0)
    static let bullet = Collisions(rawValue: 1 << 1)
}
