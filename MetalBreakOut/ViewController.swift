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

    let device = MTLCreateSystemDefaultDevice()

    @IBOutlet weak var metalView: MTKView!
    @IBOutlet weak var gameSceneView: MTKView!

    var renderer: Renderer?
    var renderer2: Renderer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        metalView.device = device
        gameSceneView.device = device

        metalView.clearColor = .skyBlue
        gameSceneView.clearColor = .wenderlichGreen
        gameSceneView.depthStencilPixelFormat = .depth32Float
        metalView.depthStencilPixelFormat = .depth32Float
        guard let device = self.device else { fatalError("failed to load device") }
        renderer = Renderer(device: device)
        renderer2 = Renderer(device: device)

        metalView.delegate = renderer
        gameSceneView.delegate = renderer2
        renderer?.scene = LandscapeScene(device: device, size: metalView.bounds.size)
        renderer2?.scene = GameScene(device: device, size: gameSceneView.bounds.size)
    }
}
