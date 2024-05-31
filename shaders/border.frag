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

const float alpha = 0.99;

const float lightHeight = 10;
const vec4 lightColor = vec4(1, 1, 1, 1);

const float attenuationCoefficient = 0.005;

float attenuation(float d) {
    return exp(-d * attenuationCoefficient);
}

mat3 rotY(float a) {
    return mat3(
        cos(a), 0, -sin(a),
        0, 1, 0,
        sin(a), 0, cos(a)
    );
}

mat3 rotZ(float a) {
    return mat3(
        cos(a), sin(a), 0,
        -sin(a), cos(a), 0,
        0, 0, 1
    );
}

struct SurfaceProps {
    vec3 N;
    float ks;
    float kd;
};

const vec3 up = vec3(0, 0, 1);

SurfaceProps calculateSurfaceTopLeft(vec2 pos) {
    const float sqDist = pow(pos.x - uBorderRadius, 2) + pow(pos.y - uBorderRadius, 2);
    const float d = sqrt(sqDist);

    if (d > uBorderRadius) {
        return SurfaceProps(up, 0, 0);
    }

    if (d < uBorderRadius - uBorderWidth) {
        return SurfaceProps(up, 0.5, 0);
    }

    const float alpha = acos((uBorderRadius - uBorderWidth / 2 - d) / (uBorderWidth / 2));
    const float beta = atan(uBorderRadius - pos.y, uBorderRadius - pos.x);

    return SurfaceProps(
        rotZ(beta) * rotY(-alpha) * vec3(1, 0, 0),
        1,
        0
    );
}

SurfaceProps calculateSurface(vec2 pos) {
    if (pos.x < uBorderRadius && pos.y < uBorderRadius) {
        return calculateSurfaceTopLeft(pos);
    }

    if (pos.x < uBorderRadius && pos.y > uSize.y - uBorderRadius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(pos.x, uSize.y - pos.y));
        props.N.y *= -1;
        return props;
    }

    if (pos.x > uSize.x - uBorderRadius && pos.y < uBorderRadius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(uSize.x - pos.x, pos.y));
        props.N.x *= -1;
        return props;
    }

    if (pos.x > uSize.x - uBorderRadius && pos.y > uSize.y - uBorderRadius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(uSize.x - pos.x, uSize.y - pos.y));
        props.N.xy *= -1;
        return props;
    }

    if (pos.x < uBorderRadius) {
        return calculateSurfaceTopLeft(vec2(pos.x, uBorderRadius));
    }

    if (pos.x > uSize.x - uBorderRadius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(uSize.x - pos.x, uBorderRadius));
        props.N.x *= -1;
        return props;
    }

    if (pos.y < uBorderRadius) {
        return calculateSurfaceTopLeft(vec2(uBorderRadius, pos.y));
    }

    if (pos.y > uSize.y - uBorderRadius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(uBorderRadius, uSize.y - pos.y));
        props.N.y *= -1;
        return props;
    }

    return SurfaceProps(up, 0.5, 0);
}

void main() {
    const vec2 pos = FlutterFragCoord().xy;

    const vec4 L0 = vec4(uCursorPos - pos, lightHeight, 0);
    const vec4 L = normalize(L0);
    const SurfaceProps props = calculateSurface(pos);
    const vec4 N = vec4(props.N, 0);
    const vec4 R = reflect(-L, N);

    const vec4 diffuse = props.kd * max(0, dot(L, N)) * lightColor;
    const vec4 specular = props.ks * pow(max(0, dot(R, V)), alpha) * lightColor;

    oColor = (diffuse + specular) * uShimmerAlpha * attenuation(length(L0));
}
