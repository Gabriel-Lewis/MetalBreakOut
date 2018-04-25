//
//  Node.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class Node {
    var name = "Untitled"
    var children: [Node] = []
    var position = float3(0)
    var rotation = float3(0)
    var scale = float3(1)
    var materialColor = float4(1)
    var specularIntensity: Float = 1
    var shininess: Float = 1
    var width: Float = 1.0
    var height: Float = 1.0

    var modelMatrix: matrix_float4x4 {
        var matrix = matrix_float4x4(translationX: position.x, y: position.y, z: position.z)
        matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.z, x: 0, y: 0, z: 1)
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        return matrix
    }


    func add(childNode child: Node) {
        children.append(child)
    }

    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        for child in children  {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
        if let renderable = self as? Renderable {
            commandEncoder.pushDebugGroup(name)
            renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
            commandEncoder.popDebugGroup()
        }
    }

    func boundingBox(_ parentModelViewMatrix: matrix_float4x4) -> CGRect {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)

        var lowerleft = float4(-self.width/2, -self.height/2, 0, 1)
        lowerleft = matrix_multiply(modelViewMatrix, lowerleft)

        var upperRight = float4(self.width/2, self.height/2, 0, 1)
        upperRight = matrix_multiply(modelViewMatrix, upperRight)

        let width = CGFloat(upperRight.x - lowerleft.x)
        let height = CGFloat(upperRight.y - lowerleft.y)

        let boundingBox = CGRect(x: CGFloat(lowerleft.x), y: CGFloat(lowerleft.y), width: width, height: height)
        return boundingBox
    }
}


