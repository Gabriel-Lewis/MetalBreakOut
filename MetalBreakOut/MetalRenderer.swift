//
//  MetalRenderer.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/18/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    var commandQueue: MTLCommandQueue!
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
    }

    func draw(drawable: MTLDrawable, descriptor: MTLRenderPassDescriptor) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let descriptor = view.currentRenderPassDescriptor else { return }
        self.draw(drawable: drawable, descriptor: descriptor)
    }
}
