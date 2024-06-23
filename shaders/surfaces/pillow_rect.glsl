#ifndef PILLOW_RECT_H
#define PILLOW_RECT_H

#include <utils/surface_props.glsl>

// Based on https://mathcurve.com/surfaces.gb/coussin/coussin.shtml
SurfaceProps calculateSurface(const vec2 pos, const vec2 size) {
    const float width = size.x;
    const float height = size.y;

    const float x = pos.x / (width / 2) - 1;
    const float y = pos.y / (height / 2) - 1;
    const float z = 15 * sqrt((1 - x*x) * (1 - y*y)) / sqrt(2);

    const float dzdx = 15 * x * (y*y - 1) / (sqrt((1 - x*x) * (1 - y*y)) * sqrt(2));
    const float dzdy = 15 * y * (x*x - 1) / (sqrt((1 - x*x) * (1 - y*y)) * sqrt(2));

    const vec3 N = vec3(-dzdx / (width / 2), -dzdy / (height / 2), 1);
    return SurfaceProps(normalize(N), 0.4, 0, z);
}

#endif // PILLOW_RECT_H
