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
    var camera = Camera()
    var sceneConstants = SceneConstants()

    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        setupCamera(size: size)
    }

    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
        }
    }

    private func setupCamera(size: CGSize) {
//        camera.aspect = Float(size.width / size.height)
        camera.position.z = -6
        add(childNode: camera)
    }

    func update(deltaTime: Float) {}

    func sceneSizeWillChange(to size: CGSize) {
        camera.aspect = Float(size.width / size.height)
    }
}
