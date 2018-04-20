//
//  GameScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import MetalKit

class GameScene: Scene {
    var plane: Plane
    var cube: Cube

    override init(device: MTLDevice, size: CGSize) {
        cube = Cube(device: device)
        plane = Plane(device: device, imageName: "picture")
        super.init(device: device, size: size)
        add(childNode: cube)
        add(childNode: plane)

        let plane2 = Plane(device: device, imageName: "picture")
        plane2.scale = float3(0.5)
        plane2.position.y = 1.5
        cube.add(childNode: plane2)

        plane.position.z = -3
        plane.position.y = -1.5
    }

    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
    }
}
