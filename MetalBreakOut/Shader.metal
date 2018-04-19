//
//  Shader.metal
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/18/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct Constants {
    float animateBy;
};


vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]],
                            constant Constants &constants [[ buffer(1) ]],
                            uint vertexId [[ vertex_id ]]) {
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    return position;
}

fragment half4 fragment_shader(constant Constants &constants [[ buffer(0) ]]) {
    return half4(constants.animateBy, 0, 1, 1);
}
