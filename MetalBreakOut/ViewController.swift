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

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    @IBOutlet weak var metalView: MTKView!

    var renderer: Renderer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }

        metalView.clearColor = .skyBlue
        metalView.depthStencilPixelFormat = .depth32Float
        renderer = Renderer(device: device)
        metalView.delegate = renderer
        renderer?.scene = LandscapeScene(device: device, size: metalView.bounds.size)
    }
}
