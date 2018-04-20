//
//  Node.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/19/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation
import MetalKit

class Node {
    var name = "Untitled"
    var children: [Node] = []


    func add(childNode child: Node) {
        children.append(child)
    }

    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children  {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    }
}


