#ifndef PILLOW_RECT_H
#define PILLOW_RECT_H

#include <utils/surface_props.glsl>

SurfaceProps calculateSurface(const vec2 pos, const vec2 size) {
    const float a = size.x / 2;
    const float b = size.y / 2;

    const float x = pos.x - a;
    const float y = pos.y - b;
    const float z = sqrt((a*a - x*x) * (b*b - y*y));

    const float dzdx = x * (y*y - b*b) / z;
    const float dzdy = y * (x*x - a*a) / z;

    const vec3 N = vec3(-dzdx, -dzdy, 1);
    return SurfaceProps(normalize(N), 1, 0);
}


#endif // PILLOW_RECT_H
