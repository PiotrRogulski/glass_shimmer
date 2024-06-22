#version 460 core

#include <flutter/runtime_effect.glsl>

#define RADIUS 16
#define SIGMA2 64
#define PI 3.14159265359

uniform vec2 uSize;
uniform float uTopHeight;
uniform float uBottomHeight;
uniform sampler2D uTexture;

out vec4 oColor;

vec4 gaussianBlur(vec2 uv, float blurFraction) {
    float sum = 0.0;
    vec4 color = vec4(0.0);
    float lastI = -2 * RADIUS;
    float lastJ = -2 * RADIUS;
    for (int i = -RADIUS; i <= RADIUS; i++) {
        float newI = floor(float(i) * blurFraction);
        if (newI == lastI) {
            continue;
        }
        lastI = newI;
        for (int j = -RADIUS; j <= RADIUS; j++) {
            float newJ = floor(float(j) * blurFraction);
            if (newJ == lastJ) {
                continue;
            }
            lastJ = newJ;
            float d = float(i * i + j * j);
            float weight = exp(-d / (2.0 * SIGMA2)) / sqrt(2.0 * PI * SIGMA2);
            vec2 targetUv = uv + vec2(float(i)-0.5, float(j)-0.5) / uSize * blurFraction;
            color += texture(uTexture, targetUv) * weight;
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
        ? smoothstep(0.0, 1.0, (uTopHeight - pos.y) / uTopHeight)
        : smoothstep(0.0, 1.0, (pos.y - uSize.y + uBottomHeight) / uBottomHeight);
    oColor = gaussianBlur(uv, blurFraction);
}
