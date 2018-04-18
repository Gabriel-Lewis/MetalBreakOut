//
//  ViewController.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/17/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import UIKit
import MetalKit
import SceneKit

class ViewController: UIViewController {

    enum BackgroundColor {
        static let green = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.0)
    }

    @IBOutlet weak var metalView: MTKView!
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!

    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = BackgroundColor.green
        metalView.delegate = self
        commandQueue = device.makeCommandQueue()
    }
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let descriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
