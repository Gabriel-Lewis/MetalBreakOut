//
//  Array+Extension.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/18/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation

extension Array {
    var length: Int {
        return self.count * MemoryLayout.stride(ofValue: self[0])
    }
}
