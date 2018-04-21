//
//  InstanceScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class InstanceScene: Scene {
    var humans: Instance

    override init(device: MTLDevice, size: CGSize) {
        humans = Instance(device: device,
                          modelName: "humanFigure",
                          instances: 40)
        super.init(device: device, size: size)
        add(childNode: humans)
        // Randomly places humans in scene
        for node in humans.nodes {
            node.scale = float3(Float(arc4random_uniform(5))/10)
            node.position.x = Float(arc4random_uniform(5)) - 2
            node.position.y = Float(arc4random_uniform(5)) - 3
            node.materialColor = float4(Float(drand48()),
                                         Float(drand48()),
                                         Float(drand48()), 1)
        }
    }

    override func update(deltaTime: Float) {

    }
}
