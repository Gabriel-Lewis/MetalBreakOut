//
//  Float.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation

extension Float {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random num Float

     - parameter min: Float
     - parameter max: Float

     - returns: Float
     */
    public static func random(_ min: Float = 0.0, _ max: Float = 1.0) -> Float {
        return Float.random * (max - min) + min
    }
}
