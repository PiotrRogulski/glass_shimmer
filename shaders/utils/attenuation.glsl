const float attenuationCoefficient = 0.005;

float attenuation(const float d) {
    return exp(-d * attenuationCoefficient);
}
