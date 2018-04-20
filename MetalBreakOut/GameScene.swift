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

    override init(device: MTLDevice, size: CGSize) {
        plane = Plane(device: device, imageName: "picture")
        super.init(device: device, size: size)
        add(childNode: plane)

        let plane2 = Plane(device: device, imageName: "picture")
        plane2.scale = float3(0.5)
        plane2.position.y = 1.5
        plane.add(childNode: plane2)
    }

    override func update(deltaTime: Float) {
        plane.rotation.y += deltaTime
    }
}
