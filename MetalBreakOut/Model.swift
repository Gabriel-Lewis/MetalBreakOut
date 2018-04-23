//
//  File.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/20/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

class Model: Node {

    var meshes: [MTKMesh]?

    // MARK: Buffers
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?

    // MARK: Renderable
    var pipelineState: MTLRenderPipelineState!

    // MARK: Textures
    var texture: MTLTexture?
    var maskTexture: MTLTexture?

    // MARK: Vertices
    var vertices: [Vertex] = []
    var indices: [UInt16] = []

    init(device: MTLDevice, modelName: String) {
        super.init()
        name = modelName
        loadModel(device: device, modelName: name)
        self.texture = setTexture(device: device, imageName: modelName)
        pipelineState = buildPipelineState(device: device)
    }

    var modelConstants = ModelConstants()

    func loadModel(device: MTLDevice, modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else { fatalError("Asset \(modelName) doesn't exist")}

        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)

        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attributePosition

        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
        attributeColor.name = MDLVertexAttributeColor

        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
        attributeTexture.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = attributeTexture

        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = attributeNormal

        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: descriptor,
                             bufferAllocator: bufferAllocator)

        do {
            meshes = try MTKMesh.newMeshes(asset: asset,
                                           device: device).metalKitMeshes
        } catch {
            print("mesh error")
        }

    }
}



extension Model: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        modelConstants.modelViewMatrix = modelViewMatrix
        modelConstants.materialColor = materialColor
        modelConstants.normalMatrix = modelViewMatrix.upperLeft3x3()


        commandEncoder.setVertexBytes(&modelConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 1)
        commandEncoder.setRenderPipelineState(pipelineState)
        guard let meshes = self.meshes, !meshes.isEmpty else { return }

        if texture != nil {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        for mesh in meshes  {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                           offset: vertexBuffer.offset,
                                           index: 0)

            for submesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }

    var fragmentFunctionName: String {
        if texture != nil {
            if maskTexture != nil {
                return "masked_textured_fragment"
            }
            return "lit_textured_fragment"
        }
        return "fragment_color"
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
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3 // Offset from position size
        vertexDescriptor.attributes[1].bufferIndex = 0

        // Texture Attribute
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0


        // Normals Attribute
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12
        return vertexDescriptor
    }
}

extension Model: Texturable {}
