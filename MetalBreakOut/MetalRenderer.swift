import MetalKit

struct Constants {
    var animateBy: Float = 0.0
}

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue

    var vertices: [Float] = [
        -1,  1, 0,
        -1, -1, 0,
         1, -1, 0,
         1,  1, 0
    ]

    let indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]

    var constant = Constants()
    var time: Float = 0
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildModel()
        buildPipelineState()
    }

    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.length,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }

    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

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
            let descriptor = view.currentRenderPassDescriptor,
        let indexBuffer = indexBuffer else { return }


        time +=  1 / Float(view.preferredFramesPerSecond)
        let animateBy = abs(sin(time) / 2 + 0.5)
        constant.animateBy = animateBy
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder =
            commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer,
                                        offset: 0, index: 0)
        commandEncoder?.setVertexBytes(&constant, length: MemoryLayout<Constants>.stride, index: 1)

        commandEncoder?.setFragmentBytes(&constant, length: MemoryLayout<Constants>.stride, index: 0)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}


