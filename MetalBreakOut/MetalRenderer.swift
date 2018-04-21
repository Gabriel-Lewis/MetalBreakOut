import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let samplerState: MTLSamplerState
    let depthStencilState: MTLDepthStencilState

    var scene: Scene?

    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        samplerState = Renderer.defaultLinearSampler(device: device)
        depthStencilState = Renderer.defaultDepthStencilState(device: device)
        super.init()
    }

}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene?.sceneSizeWillChange(to: size)
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else { return }

        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let commandEncoder =
            commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }


        let deltaTime =  1 / Float(view.preferredFramesPerSecond)
        commandEncoder.setFragmentSamplerState(samplerState, index: 0)
        commandEncoder.setDepthStencilState(depthStencilState)
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

extension Renderer {
    class func defaultLinearSampler(device: MTLDevice) -> MTLSamplerState {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter             = .linear
        sampler.magFilter             = .linear
        return device.makeSamplerState(descriptor: sampler)!
    }

    class func defaultNearestSampler(device: MTLDevice) -> MTLSamplerState {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter             = .nearest
        sampler.magFilter             = .nearest
        sampler.mipFilter             = .nearest
        sampler.maxAnisotropy         = 1
        sampler.sAddressMode          = .clampToEdge
        sampler.tAddressMode          = .clampToEdge
        sampler.rAddressMode          = .clampToEdge
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp           = 0
        sampler.lodMaxClamp           = .greatestFiniteMagnitude
        return device.makeSamplerState(descriptor: sampler)!
    }

    class func defaultDepthStencilState(device: MTLDevice) -> MTLDepthStencilState {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
}


