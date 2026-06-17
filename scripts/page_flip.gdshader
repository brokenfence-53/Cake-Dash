shader_type canvas_item;

// 0.0 = flat / no flip, 1.0 = fully flipped (showing back face edge-on)
uniform float flip_progress : hint_range(0.0, 1.0) = 0.0;

// How dark the surface gets at the edge-on point, simulates light falloff
uniform float shade_strength : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    float angle = flip_progress * PI;
    float squish = cos(angle);

    vec2 centered_uv = UV - 0.5;
    centered_uv.x /= max(abs(squish), 0.001);

    vec2 final_uv = centered_uv + 0.5;

    // Default to transparent
    vec4 tex_color = vec4(0.0);

    // Only sample if inside valid UV range
    if (final_uv.x >= 0.0 && final_uv.x <= 1.0) {
        tex_color = texture(TEXTURE, final_uv);

        float shade = 1.0 - (1.0 - abs(squish)) * shade_strength;
        tex_color.rgb *= shade;
    }

    COLOR = tex_color;
}
