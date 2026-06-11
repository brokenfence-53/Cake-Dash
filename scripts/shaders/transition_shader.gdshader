shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 dot_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float dot_radius = 0.25;   // Dot size (0–0.5)
uniform float spacing = 0.5;       // Distance between dots
uniform float speed = 0.5;         // Scroll speed

void fragment() {
    vec2 uv = UV;

    // Move dots to the right
    uv.x += TIME * speed;

    // Scale UV so multiple dots appear
    uv /= spacing;

    // Repeat pattern
    vec2 grid = fract(uv);

    // Center of each cell
    vec2 center = grid - 0.5;

    // Distance from center
    float dist = length(center);

    // Dot mask
    float dot = step(dist, dot_radius);

    // Final color
    COLOR = mix(bg_color, dot_color, dot);
}
