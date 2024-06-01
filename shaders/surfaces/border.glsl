#ifndef BORDER_H
#define BORDER_H

#include <utils/surface_props.glsl>

mat3 rotY(const float a) {
    return mat3(
        cos(a), 0, -sin(a),
        0, 1, 0,
        sin(a), 0, cos(a)
    );
}

mat3 rotZ(const float a) {
    return mat3(
        cos(a), sin(a), 0,
        -sin(a), cos(a), 0,
        0, 0, 1
    );
}

const vec3 up = vec3(0, 0, 1);

SurfaceProps calculateSurfaceTopLeft(const vec2 pos, const float radius, const float width) {
    const float sqDist = pow(pos.x - radius, 2) + pow(pos.y - radius, 2);
    const float d = sqrt(sqDist);

    if (d > radius) {
        return SurfaceProps(up, 0, 0);
    }

    if (d < radius - width) {
        return SurfaceProps(up, 0.25, 0);
    }

    const float alpha = acos((radius - width / 2 - d) / (width / 2));
    const float beta = atan(radius - pos.y, radius - pos.x);

    return SurfaceProps(
        rotZ(beta) * rotY(-alpha) * vec3(1, 0, 0),
        1,
        0
    );
}

SurfaceProps calculateSurface(const vec2 pos, const vec2 size, const float radius, const float width) {
    if (pos.x < radius && pos.y < radius) {
        return calculateSurfaceTopLeft(pos, radius, width);
    }

    if (pos.x < radius && pos.y > size.y - radius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(pos.x, size.y - pos.y), radius, width);
        props.N.y *= -1;
        return props;
    }

    if (pos.x > size.x - radius && pos.y < radius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(size.x - pos.x, pos.y), radius, width);
        props.N.x *= -1;
        return props;
    }

    if (pos.x > size.x - radius && pos.y > size.y - radius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(size.x - pos.x, size.y - pos.y), radius, width);
        props.N.xy *= -1;
        return props;
    }

    if (pos.x < radius) {
        return calculateSurfaceTopLeft(vec2(pos.x, radius), radius, width);
    }

    if (pos.x > size.x - radius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(size.x - pos.x, radius), radius, width);
        props.N.x *= -1;
        return props;
    }

    if (pos.y < radius) {
        return calculateSurfaceTopLeft(vec2(radius, pos.y), radius, width);
    }

    if (pos.y > size.y - radius) {
        SurfaceProps props = calculateSurfaceTopLeft(vec2(radius, size.y - pos.y), radius, width);
        props.N.y *= -1;
        return props;
    }

    return SurfaceProps(up, 0.25, 0);
}

#endif // BORDER_H
