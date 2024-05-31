#version 460 core

#include <flutter/runtime_effect.glsl>

#define M_PI 3.1415926535897932384626433832795

uniform vec2 uSize;
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

mat4 rotY(float a) {
    return mat4(
        cos(a), 0, -sin(a), 0,
        0, 1, 0, 0,
        sin(a), 0, cos(a), 0,
        0, 0, 0, 1
    );
}

mat4 rotZ(float a) {
    return mat4(
        cos(a), sin(a), 0, 0,
        -sin(a), cos(a), 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    );

}

vec4 calculateNormalTopLeft(vec2 pos) {
    const float sqDist = pow(pos.x - uBorderRadius, 2) + pow(pos.y - uBorderRadius, 2);
    const float d = sqrt(sqDist);

    if (d > uBorderRadius || d < uBorderRadius - uBorderWidth) {
        return vec4(0, 0, 0, 0);
    }

    const float alpha = acos((uBorderRadius - uBorderWidth / 2 - d) / (uBorderWidth / 2));
    const float beta = atan(uBorderRadius - pos.y, uBorderRadius - pos.x);

    return rotZ(beta) * rotY(-alpha) * vec4(1, 0, 0, 0);
}

vec4 calculateNormal(vec2 pos) {
    if (pos.x < uBorderRadius && pos.y < uBorderRadius) {
        return calculateNormalTopLeft(pos);
    }

    // TODO: do other corners
    return calculateNormalTopLeft(pos);
}

void main() {
    const vec2 pos = FlutterFragCoord().xy;

    const vec4 L = normalize(vec4(uCursorPos - pos, lightHeight, 0));
    const vec4 N = calculateNormal(pos);
    const vec4 R = reflect(-L, N);

    const vec4 diffuse = kd * max(0, dot(L, N)) * lightColor;
    const vec4 specular = ks * pow(max(0, dot(R, V)), alpha) * lightColor;

    oColor = (diffuse + specular) * uShimmerAlpha;
}
