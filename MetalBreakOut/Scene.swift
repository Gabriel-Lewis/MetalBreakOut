//
//  Scene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import MetalKit

class Scene: Node {

    var device: MTLDevice
    var size: CGSize

    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }

    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }

    func update(deltaTime: Float) {}
}
