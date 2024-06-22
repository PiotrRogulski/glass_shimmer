#version 460 core

#include <flutter/runtime_effect.glsl>

#define RADIUS 16
#define SIGMA2 25
#define PI 3.14159265359

uniform vec2 uSize;
uniform float uTopHeight;
uniform float uBottomHeight;
uniform sampler2D uTexture;

out vec4 oColor;

vec4 gaussianBlur(vec2 uv, float blurFraction) {
    float sum = 0.0;
    vec4 color = vec4(0.0);
    for (int i = -RADIUS; i <= RADIUS; i++) {
        for (int j = -RADIUS; j <= RADIUS; j++) {
            float d = float(i * i + j * j);
            float weight = exp(-d / (2.0 * SIGMA2)) / (2.0 * PI * SIGMA2);
            color += texture(uTexture, uv + vec2(float(i), float(j)) / uSize * blurFraction) * weight;
            sum += weight;
        }
    }
    return color / sum;
}

void main() {
    const vec2 pos = FlutterFragCoord().xy;
    const vec2 uv = pos / uSize;

    if (pos.y > uTopHeight && pos.y < uSize.y - uBottomHeight) {
        oColor = texture(uTexture, uv);
        return;
    }

    const float blurFraction = pos.y <= uTopHeight
        ? (uTopHeight - pos.y) / uTopHeight
        : (pos.y - uSize.y + uBottomHeight) / uBottomHeight;
    oColor = gaussianBlur(uv, blurFraction);
}
