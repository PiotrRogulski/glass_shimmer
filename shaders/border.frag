#version 460 core

#include <flutter/runtime_effect.glsl>
#include <utils/calculate_color.glsl>
#include <utils/surface_props.glsl>
#include <surfaces/border.glsl>

uniform vec2 uSize;
uniform vec2 uCursorPos;
uniform float uBorderRadius;
uniform float uBorderWidth;
uniform float uAlpha;

out vec4 oColor;

void main() {
    const vec2 pos = FlutterFragCoord().xy;

    const SurfaceProps props = calculateSurface(pos, uSize, uBorderRadius, uBorderWidth);

    oColor = calculateColor(pos, props, uAlpha, uCursorPos);
}