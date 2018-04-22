//
//  Constants.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import simd

struct Constants {
    var animateBy: Float = 0.0
}

struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
    var materialColor = float4(1)
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}


struct Light {
    var color = float3(1)
    var ambientIntensity: Float = 1.0
}
