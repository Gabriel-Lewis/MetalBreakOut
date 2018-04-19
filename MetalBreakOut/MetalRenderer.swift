import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState?
    var scene: Scene?

    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildPipelineState()
    }

    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm


        // TODO Refactor this:
        let vertexDecscriptor = MTLVertexDescriptor()
        // Describes the position attribute
        vertexDecscriptor.attributes[0].format = .float3
        vertexDecscriptor.attributes[0].offset = 0
        vertexDecscriptor.attributes[0].bufferIndex = 0
        // Describes the color attribute
        vertexDecscriptor.attributes[1].format = .float4
        vertexDecscriptor.attributes[1].offset = MemoryLayout<float3>.stride // is offset from position size
        vertexDecscriptor.attributes[1].bufferIndex = 0

        // size of the information held for each vertex
        vertexDecscriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

        pipelineDescriptor.vertexDescriptor = vertexDecscriptor
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else { return }



        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let commandEncoder =
            commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        commandEncoder.setRenderPipelineState(pipelineState)

        let deltaTime =  1 / Float(view.preferredFramesPerSecond)
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}


