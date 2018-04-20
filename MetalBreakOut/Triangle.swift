//
//  Triangle.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import MetalKit

class Triangle: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var vertices: [Float] = [
        0,  1, -0.1,
        -1, -1, -0.1,
        1, -1, -0.1
    ]
    var constants: Constants

    init(device: MTLDevice) {
        constants = Constants(animateBy: 0.0)
        super.init()
        buildBuffers(device: device)
    }

    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.length,
                                         options: [])
    }
}
