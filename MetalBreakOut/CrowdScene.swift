//
//  CrowdScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class CrowdScene: Scene {
    var humans: [Model] = []
    override init(device: MTLDevice, size: CGSize) {
        super.init(device: device, size: size)
        for _ in 0...41 {
            let human = Model(device: device, modelName: "humanFigure")
            humans.append(human)
            add(childNode: human)
            human.scale = float3(Float.random)
            human.position.x = Float.random
            human.position.y = Float.random
            human.materialColor = float4(Float.random, Float.random, Float.random, 1)
        }
    }

    override func update(deltaTime: Float) {
        
    }
}
