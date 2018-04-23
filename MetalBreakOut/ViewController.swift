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

        metalView.clearColor = .wenderlichGreen
        metalView.depthStencilPixelFormat = .depth32Float
        guard let device = self.device else { fatalError("failed to load device") }
        renderer = Renderer(device: device)
        renderer?.scene = GameScene(device: device, size: metalView.bounds.size)
        gameSceneView.isHidden = true
        metalView.delegate = renderer
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesBegan(view, touches:touches,
                                      with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesEnded(view, touches: touches,
                                      with: event)

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesMoved(view, touches: touches,
                                      with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesCancelled(view, touches: touches,
                                          with: event)
    }
}
