const float attenuationCoefficient = 0.003;

float attenuation(const float d) {
    return exp(-d * attenuationCoefficient);
}
