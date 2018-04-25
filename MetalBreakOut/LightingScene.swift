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

        mushroom.specularIntensity = 0.2
        mushroom.shininess = 2.0
        mushroom.position.y = -1
        add(childNode: mushroom)

        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.2
        light.diffuseIntensity = 0.8
        light.direction = float3(0, 0, -1)
    }

    override func update(deltaTime: Float) {

    }

    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousTouchLocation = touch.location(in: view)
    }

    override func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        let sensitivity: Float = 0.01
        let delta = CGPoint(x: previousTouchLocation.x - touchLocation.x,
                            y: previousTouchLocation.y - touchLocation.y)
        mushroom.rotation.x += Float(delta.y) * sensitivity
        mushroom.rotation.y += Float(delta.x) * sensitivity
        previousTouchLocation = touchLocation
    }
}
