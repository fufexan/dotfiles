#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 resolution;
    vec4 fillColor;
    vec4 progressColor;
    vec4 strokeColor;
    float strokeWidth;
    float radius;
    float power;
    float progress;
    float useTexture; // 1.0 to use the texture, 0.0 for solid/progress fill
};

// The texture provided by ShaderEffectSource or Image
layout(binding = 1) uniform sampler2D sourceTexture;

float sdSquircleRect(vec2 p, vec2 b, float r, float n) {
    vec2 q = abs(p) - (b - r);
    if (q.x > 0.0 && q.y > 0.0) {
        return pow(pow(q.x, n) + pow(q.y, n), 1.0 / n) - r;
    }
    return max(q.x, q.y) - r;
}

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678;
    return 1.0 - smoothstep(threshold - afwidth, threshold + afwidth, value);
}

void main() {
    vec2 p = (qt_TexCoord0 * resolution) - (resolution * 0.5);
    vec2 halfSize = resolution * 0.5;

    float dist = sdSquircleRect(p, halfSize, radius, power);
    float shapeMask = aastep(0.0, dist);

    // 1. Determine the base content color
    vec4 baseContent;
    if (useTexture > 0.5) {
        // Sample the texture (clipped image/layout)
        baseContent = texture(sourceTexture, qt_TexCoord0);
    } else {
        // Calculate solid fill or progress bar color
        float isProgress = 1.0 - smoothstep(progress - 0.001, progress + 0.001, qt_TexCoord0.x);
        baseContent = mix(fillColor, progressColor, isProgress);
    }

    // 2. Apply Stroke and Opacity logic
    if (strokeWidth > 0.0) {
        float innerMask = aastep(-strokeWidth, dist);
        vec3 color = mix(strokeColor.rgb, baseContent.rgb, innerMask);
        float alpha = shapeMask * mix(strokeColor.a, baseContent.a, innerMask);
        fragColor = vec4(color * alpha, alpha) * qt_Opacity;
    } else {
        float alpha = shapeMask * baseContent.a;
        fragColor = vec4(baseContent.rgb * alpha, alpha) * qt_Opacity;
    }
}
