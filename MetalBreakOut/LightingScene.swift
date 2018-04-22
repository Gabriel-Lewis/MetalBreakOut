//
//  LightingScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/21/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class LightingScene: Scene {
    let mushroom: Model

    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
        add(childNode: mushroom)
        light.color = float3(0, 0, 1)
        light.ambientIntensity = 0.5
        mushroom.position.y = -1


    }

    override func update(deltaTime: Float) {

    }
}
