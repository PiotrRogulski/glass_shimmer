#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uCursorPos;
uniform float uBorderRadius;
uniform float uBorderWidth;
uniform float uShimmerAlpha;

out vec4 oColor;

const vec4 V = vec4(0, 0, 1, 0);

const float ks = 0.5;
const float kd = 0;
const float alpha = 0.99;

const float lightHeight = 10;
const vec4 lightColor = vec4(1, 1, 1, 1);

void main() {
    const vec2 pos = FlutterFragCoord().xy;

    const vec4 L = normalize(vec4(uCursorPos - pos, lightHeight, 0));
    // TODO: calculate normal vector
    const vec4 N = normalize(vec4(0, 0, 1, 0));
    const vec4 R = reflect(-L, N);

    const vec4 diffuse = kd * max(0, dot(L, N)) * lightColor;
    const vec4 specular = ks * pow(max(0, dot(R, V)), alpha) * lightColor;

    oColor = (diffuse + specular) * uShimmerAlpha;
}
