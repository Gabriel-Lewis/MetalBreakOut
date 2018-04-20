//
//  Primitive.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class Primitive: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?

    // Renderable
    var pipelineState: MTLRenderPipelineState!

    var texture: MTLTexture?
    var maskTexture: MTLTexture?

    var vertices: [Vertex] = []
    var indices: [UInt16] = []

    init(device: MTLDevice, imageName: String? = nil, maskImageName: String? = nil) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        self.texture = setTexture(device: device, imageName: imageName)
        self.maskTexture = setTexture(device: device, imageName: maskImageName)
        pipelineState = buildPipelineState(device: device)
    }

    var time: Float = 0
    var modelConstants = ModelConstants()


    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }

    func buildVertices() {}
}

extension Primitive: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let indexBuffer = indexBuffer else { return }

        let aspect = Float(750.0/1334.0)
        let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 65),
                                               aspect: aspect,
                                               nearZ: 0.1,
                                               farZ: 100)

        modelConstants.modelViewMatrix = matrix_multiply(projectionMatrix, modelViewMatrix)

        commandEncoder.setRenderPipelineState(pipelineState)

        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)

        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.setFragmentTexture(maskTexture, index: 1)

        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)

    }

    var fragmentFunctionName: String {
        if texture != nil {
            if maskTexture != nil {
                return "masked_textured_fragment"
            }
            return "textured_fragment"
        }
        return "fragment_shader"
    }

    var vertexFunctionName: String {
        return "vertex_shader"
    }

    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor =  MTLVertexDescriptor()
        // Position attribute
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        // Color attribute
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride // Offset from position size
        vertexDescriptor.attributes[1].bufferIndex = 0

        // Texture Attribute
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
}

extension Primitive: Texturable {}
