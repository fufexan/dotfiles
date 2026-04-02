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
    float useTexture;
};

layout(binding = 1) uniform sampler2D sourceTexture;

float sdSquircleRect(vec2 p, vec2 b, float r, float n) {
    vec2 q = abs(p) - (b - r);
    if (q.x > 0.0 && q.y > 0.0) {
        return pow(pow(q.x, n) + pow(q.y, n), 1.0 / n) - r;
    }
    return max(q.x, q.y) - r;
}

void main() {
    vec2 p = (qt_TexCoord0 - 0.5) * resolution;
    vec2 halfSize = resolution * 0.5;

    float dist = sdSquircleRect(p, halfSize, radius, power);

    // This calculates the width of a single physical pixel in SDF units
    float pixelWidth = fwidth(dist);

    // Create a sharp mask with exactly 1-pixel of antialiasing
    // Edge is at 0.0, smoothing happens between -pixelWidth and 0.0
    float outerEdge = smoothstep(0.0, -pixelWidth, dist);

    // Inner edge for the stroke
    // If you want a 1px border, strokeWidth should be 1.0
    float innerEdge = smoothstep(-strokeWidth, -strokeWidth + pixelWidth, dist);

    vec4 baseContent;
    if (useTexture > 0.5) {
        baseContent = texture(sourceTexture, qt_TexCoord0);
    } else {
        float isProgress = smoothstep(progress + 0.01, progress - 0.01, qt_TexCoord0.x);
        baseContent = mix(fillColor, progressColor, isProgress);
    }

    // Blend logic:
    // We use the stroke color as the base, then overlay the content inside the inner edge.
    // Finally, we clip the whole thing by the outer edge.
    vec4 finalColor = mix(baseContent, strokeColor, innerEdge);

    // Apply outer clipping and global opacity
    float alpha = outerEdge * qt_Opacity;

    // Standard Premultiplied Alpha output for Qt
    fragColor = vec4(finalColor.rgb * finalColor.a, finalColor.a) * alpha;
}
