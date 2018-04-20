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

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0,
                                               green: 0.4,
                                               blue: 0.21,
                                               alpha: 1.0)
}

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    var metalView: MTKView {
        return view as! MTKView
    }

    var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }


        metalView.clearColor =  Colors.wenderlichGreen
        metalView.depthStencilPixelFormat = .depth32Float
        renderer = Renderer(device: device)
        metalView.delegate = renderer
        renderer?.scene = GameScene(device: device, size: view.bounds.size)
    }
}
