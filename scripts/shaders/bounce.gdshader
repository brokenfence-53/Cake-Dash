shader_type canvas_item;

group_uniforms Sine;
uniform bool do_abs;
uniform bool do_quantize;
uniform float quantize_to : hint_range(0, 2, 0.1) = 1;
uniform vec2 sine_amplitude = vec2(5.0, 5.0); // Increased amplitude for larger movement range
uniform vec2 sine_speed = vec2(10.0, 0.0);
uniform vec2 sine_phase = vec2(0.0, 0.0);

void vertex() {
    vec2 s = sin(TIME * sine_speed + sine_phase);
    if (do_abs) {
        s = abs(s);
    }
    s = smoothstep(-1.0, 1.0, s);
    VERTEX += s * sine_amplitude; // Larger amplitude makes vertices move further
    if (do_quantize) {
        VERTEX = round(VERTEX / quantize_to);
        VERTEX *= quantize_to;
    }
}

// Credit: https://godotshaders.com/shader/bounce-wave/