//
//  GameOverScene.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/23/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class GameOverScene: Scene {

    var gameOverModel: Model!

    var win: Bool = false {
        didSet {
            if win {
                gameOverModel = Model(device: device, modelName: "youwin")
                gameOverModel.materialColor = float4(0, 1, 0, 1)
            } else {
                gameOverModel = Model(device: device, modelName: "youlose")
                gameOverModel.materialColor = float4(1, 0, 0, 1)
            }
            setupLighting()
            camera.position.z = -30
        }
    }


    private func setupLighting() {
        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.3
        light.diffuseIntensity = 0.8
        light.direction = float3(0, -1, -1)
    }

    override init(device: MTLDevice, size: CGSize) {
        super.init(device: device, size: size)
         add(childNode: gameOverModel)
    }

    override func update(deltaTime: Float) {

    }
}
