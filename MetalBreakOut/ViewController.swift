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
    

    var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.clearColor = BackgroundColor.green
        guard let device = metalView.device else { fatalError("can't build on simulator") }
        renderer = Renderer(device: device)
        metalView.delegate = renderer
    }
}
