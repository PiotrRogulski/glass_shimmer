#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uCursorPos;
uniform float uMaxDist;
uniform float uShimmerAlpha;
uniform sampler2D uTexture;

out vec4 oColor;

void main() {
    const vec2 pos = FlutterFragCoord().xy;
    const float cursorDist = distance(pos, uCursorPos);
    const float alpha = 1.0 - smoothstep(0.0, uMaxDist, cursorDist);

    oColor = texture(uTexture, pos / uSize) * alpha * uShimmerAlpha;
}
