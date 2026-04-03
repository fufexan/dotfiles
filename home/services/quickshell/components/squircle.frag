#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 resolution;       // Physical pixels: Qt.size(w * dpr, h * dpr)
    vec4 fillColor;        // Background/Base color
    vec4 progressColor;    // Color for the progress bar fill
    vec4 strokeColor;      // Outer border color
    vec4 innerStrokeColor; // Inner rim color
    float strokeWidth;     // Width in physical pixels
    float innerStrokeWidth;
    float useInnerStroke;  // 1.0 to enable, 0.0 to disable
    float radius;          // Corner radius in physical pixels
    float power;           // Squircle exponent
    float progress;        // 0.0 to 1.0
    float useTexture;      // 1.0 to use sourceTexture, 0.0 for solid/progress
};

layout(binding = 1) uniform sampler2D sourceTexture;

// Signed Distance Function for a rounded superellipse / squircle-like rect.
// p: point in local pixel space, centered at 0
// b: half-size in pixels
// r: radius in pixels
// n: exponent (higher = squarer corners, lower = rounder)
float sdSquircleRect(vec2 p, vec2 b, float r, float n) {
    vec2 q = abs(p) - (b - vec2(r));

    if (q.x > 0.0 && q.y > 0.0) {
        return pow(pow(q.x, n) + pow(q.y, n), 1.0 / n) - r;
    }

    return max(q.x, q.y) - r;
}

// Straight-alpha "src over dst" compositing.
vec4 over(vec4 dst, vec4 src) {
    float outA = src.a + dst.a * (1.0 - src.a);

    vec3 outRGB = vec3(0.0);
    if (outA > 0.0) {
        outRGB =
            (src.rgb * src.a + dst.rgb * dst.a * (1.0 - src.a)) / outA;
    }

    return vec4(outRGB, outA);
}

void main() {
    // Local coordinates in physical pixel space, centered on the item.
    vec2 p = (qt_TexCoord0 - 0.5) * resolution;
    vec2 halfSize = resolution * 0.5;

    // Signed distance to the outer shape edge.
    float dist = sdSquircleRect(p, halfSize, radius, power);

    // Derivative-based AA width in physical pixels.
    float aa = max(fwidth(dist), 1e-4);

    // Main shape coverage: 1 inside, 0 outside.
    float shapeMask = 1.0 - smoothstep(0.0, aa, dist);

    // "Inside after outer stroke" coverage.
    // This is 0 in the outer border band, 1 deeper inside.
    float insideAfterOuterStroke = 1.0;
    if (strokeWidth > 0.0) {
        float tOuter = -strokeWidth;
        insideAfterOuterStroke = 1.0 - smoothstep(tOuter, tOuter + aa, dist);
    }

    // "Inside after inner stroke" coverage.
    float insideAfterInnerStroke = insideAfterOuterStroke;
    float innerWidth = (useInnerStroke > 0.5) ? innerStrokeWidth : 0.0;
    if (innerWidth > 0.0) {
        float tInner = -(strokeWidth + innerWidth);
        insideAfterInnerStroke = 1.0 - smoothstep(tInner, tInner + aa, dist);
    }

    // Base content: texture or fill/progress.
    vec4 content;
    if (useTexture > 0.5) {
        vec4 tex = texture(sourceTexture, qt_TexCoord0);
        content = over(fillColor, tex);
    } else {
        // Anti-aliased progress edge for better appearance on 1x displays
        // and during animation.
        float progAA = max(fwidth(qt_TexCoord0.x), 1e-4);
        float progressMask =
            1.0 - smoothstep(progress - progAA, progress + progAA, qt_TexCoord0.x);
        content = mix(fillColor, progressColor, progressMask);
    }

    // Compose inner layers first, then clip with shape at the end.
    vec4 result = content;

    // Inner stroke/rim: the band between outer-stroke boundary and inner-stroke boundary.
    if (useInnerStroke > 0.5 && innerStrokeWidth > 0.0) {
        float rimMask = insideAfterOuterStroke * (1.0 - insideAfterInnerStroke);
        vec4 rimLayer = vec4(innerStrokeColor.rgb, innerStrokeColor.a * rimMask);
        result = over(result, rimLayer);
    }

    // Outer stroke: the band between the shape edge and the start of content.
    if (strokeWidth > 0.0) {
        float outerStrokeMask = 1.0 - insideAfterOuterStroke;
        vec4 strokeLayer = vec4(strokeColor.rgb, strokeColor.a * outerStrokeMask);
        result = over(result, strokeLayer);
    }

    // Final shape clip and Qt opacity.
    float outA = result.a * shapeMask * qt_Opacity;
    fragColor = vec4(result.rgb * outA, outA);
}
