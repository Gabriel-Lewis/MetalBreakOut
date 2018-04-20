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
        plane = Plane(device: device, imageName: "picture", maskImageName: "picture-frame-mask")
        super.init(device: device, size: size)
        add(childNode: plane)
        let picturePlane = Plane(device: device, imageName: "picture-frame")
        add(childNode: picturePlane)
    }
}
