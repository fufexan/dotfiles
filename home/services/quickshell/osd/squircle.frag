#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 selectionColor;
    vec4 fillWeightColor;
    float exponent;
    float progress;
    float ratio;
} ubuf;

void main() {
    vec2 uv = qt_TexCoord0 * 2.0 - 1.0;
    float aspect = ubuf.ratio;

    // Improved aspect correction: Map only the rounded "caps"
    // This keeps the curve shape identical regardless of bar width.
    float x_fixed = max(0.0, abs(uv.x) * aspect - (aspect - 1.0));

    // Calculate distance with a higher baseline for the power function
    // This helps keep the "internal" part of the shape solid.
    float dist = pow(abs(x_fixed), ubuf.exponent) + pow(abs(uv.y), ubuf.exponent);

    // Tighter Anti-Aliasing
    // We calculate the derivative (gradient) to find the exact pixel width.
    // Reducing the multiplier from 1.5 to 0.5 - 0.7 makes the edge sharper.
    float delta = fwidth(dist) * 0.6;
    float alpha = 1.0 - smoothstep(1.0 - delta, 1.0 + delta, dist);

    // Determine color
    vec4 baseColor = (qt_TexCoord0.x <= ubuf.progress) ? ubuf.fillWeightColor : ubuf.selectionColor;

    // Premultiply alpha (standard for Qt shaders to avoid dark fringes)
    fragColor = baseColor * alpha * ubuf.qt_Opacity;
}
