//
//  LandscapeScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

 import MetalKit

class LandscapeScene: Scene {

    let sun: Model

    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        sun.materialColor = float4(1, 1, 0, 1)
        super.init(device: device, size: size)
        add(childNode: sun)
    }

    override func update(deltaTime: Float) {

    }
}
