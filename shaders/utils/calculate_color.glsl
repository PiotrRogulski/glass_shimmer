#include <utils/attenuation.glsl>
#include <utils/surface_props.glsl>

const float specularAlpha = 0.99;

const float baseLightHeight = 15;
const vec4 lightColor = vec4(1, 1, 1, 1);

const vec4 V = vec4(0, 0, 1, 0);

vec4 calculateColor(const vec3 pos, const SurfaceProps props, const float alpha, const vec2 cursorPos) {
    const float lightHeight = baseLightHeight + 300 * (1 - alpha);

    const vec4 L0 = vec4(vec3(cursorPos, lightHeight) - pos, 0);
    const vec4 L = normalize(L0);
    const vec4 N = vec4(props.N, 0);
    const vec4 R = reflect(-L, N);

    const vec4 diffuse = props.kd * max(0, dot(L, N)) * lightColor;
    const vec4 specular = props.ks * pow(max(0, dot(R, V)), specularAlpha) * lightColor;

    return (diffuse + specular) * alpha * attenuation(length(L0));
}
