shader_type canvas_item;

uniform float scroll_speed = 0.2; 
uniform float scale = 1.0;

void fragment() {
    vec2 uv = UV * scale;

    uv.x += TIME * scroll_speed;

    uv = fract(uv);

    COLOR = texture(TEXTURE, uv);
}
