//
//  Instance.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class Instance: Node {
    var model: Model
    var nodes: [Node] = []
    var instanceConstants: [ModelConstants] = []

    var modelConstants = ModelConstants()

    var instanceBuffer: MTLBuffer?

    var pipelineState: MTLRenderPipelineState!

    init(device: MTLDevice, modelName: String, instances: Int) {

        model = Model(device: device, modelName: modelName)
        super.init()
        name = modelName
        create(instancesCount: instances)
        makeBuffer(device: device)
        pipelineState = buildPipelineState(device: device)
    }


    func create(instancesCount count: Int) {
        for i in 0..<count {
            let node = Node()
            node.name = "Instance \(i)"
            nodes.append(node)
            instanceConstants.append(ModelConstants())
        }
    }

    func makeBuffer(device: MTLDevice) {
        instanceBuffer = device.makeBuffer(length: instanceConstants.count * MemoryLayout<ModelConstants>.stride,
                                           options: [])
        instanceBuffer?.label = "Instance Buffer"
    }

}

extension Instance: Renderable {

    var vertexFunctionName: String {
        return "vertex_instance_shader"
    }

    var fragmentFunctionName: String {
        return model.fragmentFunctionName
    }

    var vertexDescriptor: MTLVertexDescriptor {
        return model.vertexDescriptor
    }

    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let instanceBuffer = instanceBuffer, !nodes.isEmpty else { return }

        var pointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)

        for node in nodes {
            pointer.pointee.modelViewMatrix = matrix_multiply(modelViewMatrix, node.modelMatrix)
            pointer.pointee.materialColor = node.materialColor
            let normal = matrix_multiply(modelViewMatrix, node.modelMatrix).upperLeft3x3()
            pointer.pointee.normalMatrix = normal
            pointer.pointee.shininess = node.shininess
            pointer.pointee.specularIntensity = node.specularIntensity
             pointer = pointer.advanced(by: 1)
        }

        commandEncoder.setFragmentTexture(model.texture, index: 0)
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 1)

        guard let meshes = model.meshes, !meshes.isEmpty else { return }
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                           offset: vertexBuffer.offset,
                                           index: 0)
            for subMesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(type: subMesh.primitiveType,
                                                     indexCount: subMesh.indexCount,
                                                     indexType: subMesh.indexType,
                                                     indexBuffer: subMesh.indexBuffer.buffer,
                                                     indexBufferOffset: subMesh.indexBuffer.offset,
                                                     instanceCount: nodes.count)
            }
        }
        
    }
}
