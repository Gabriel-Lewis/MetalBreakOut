//
//  Texturable.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }

}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String?) -> MTLTexture? {
        guard let name = imageName else { return nil }
        guard let url = Bundle.main.url(forResource: name, withExtension: "png") else { return nil }
        let textureLoader = MTKTextureLoader(device: device)
        var tex: MTLTexture?
        do {
            tex = try textureLoader.newTexture(URL: url, options: [.origin: MTKTextureLoader.Origin.bottomLeft])
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return tex
    }
}
