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

    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder.setFragmentBytes(&constants, length: MemoryLayout<Constants>.stride, index: 0)
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 1, instanceCount: 1)
    }
}
