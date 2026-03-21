shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.18, 0.36, 0.23, 1.0);   // #2F5D3A
uniform vec4 color_bottom : source_color = vec4(0.14, 0.29, 0.18, 1.0); // #234B2E

uniform float noise_strength = 0.04;
uniform float noise_scale = 200.0;

// Simple hash noise
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    // Gradient (top to bottom)
    float t = UV.y;
    vec3 gradient = mix(color_top.rgb, color_bottom.rgb, t);

    // Noise
    float n = random(UV * noise_scale);
    n = (n - 0.5) * noise_strength;

    // Vignette
    float dist = distance(UV, vec2(0.5));
    float vignette = smoothstep(0.95, 0.3, dist);
    gradient *= vignette;

    // Final color
    COLOR = vec4(gradient + n, 1.0);
}
