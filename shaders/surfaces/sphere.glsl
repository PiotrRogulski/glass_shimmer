#ifndef SPHERE_H
#define SPHERE_H

#include <utils/surface_props.glsl>

const vec3 up = vec3(0, 0, 1);

SurfaceProps calculateSurface(const vec2 pos, const vec2 size) {
    const float width = size.x;
    const float height = size.y;
    const float maxZ = min(width, height) / 2;

    const float x = pos.x / (width / 2) - 1;
    const float y = pos.y / (height / 2) - 1;
    const float r = sqrt(x * x + y * y);
    if (r > 1) {
        return SurfaceProps(up, 0, 0, 0);
    }
    const float z = sqrt(1 - r * r);
    const vec3 N = vec3(x / (width / 2), y / (height / 2), z / maxZ);
    return SurfaceProps(normalize(N), 0.5, 0, z * maxZ);
}

#endif // SPHERE_H
