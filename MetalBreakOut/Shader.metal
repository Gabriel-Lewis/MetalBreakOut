//
//  Shader.metal
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/18/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
    float4 materialColor;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 textureCoordinates;
    float4 materialColor;
};


vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants  [[ buffer(2) ]]) {
    VertexOut vertexOut;

    // Applies the scene projection matrix to the models view Matrix
    float4x4 matrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;

    // Applies the models world space matrix to the passed in position
    vertexOut.position = matrix * vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.materialColor = modelConstants.materialColor;
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    float4 color = vertexIn.color;
    return half4(color);
}


fragment half4 fragment_color(VertexOut vertexIn [[ stage_in  ]]) {
    return half4(vertexIn.materialColor);
}

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                 sampler sampler2d [[ sampler(0) ]],
                                 texture2d<float> texture [[ texture(0) ]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    color = color * vertexIn.materialColor;
    if (color.a == 0.0) discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}


fragment half4 masked_textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                 sampler sampler2d [[ sampler(0) ]],
                                 texture2d<float> texture [[ texture(0) ]],
                                 texture2d<float> maskTexture [[ texture(1) ]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    float maskOpacity = maskColor.a;
    if (maskOpacity < 0.5) discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}
