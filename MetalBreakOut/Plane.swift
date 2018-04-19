//
//  Plane.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import MetalKit

class Plane: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
    
    var vertices: [Float] = [
        -1,  1, 0,
        -1, -1, 0,
        1, -1, 0,
        1, 1, 0
    ]
    var indices: [UInt16] = [
        0, 1, 2,
        0, 2, 3
    ]

    var time: Float = 0
    var constants = Constants()


    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.length,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }

    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        guard let indexBuffer = self.indexBuffer else { return }

        time += deltaTime
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animateBy = animateBy

        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder.setFragmentBytes(&constants, length: MemoryLayout<Constants>.stride, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
