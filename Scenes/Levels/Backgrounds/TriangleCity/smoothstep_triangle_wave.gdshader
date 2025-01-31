shader_type canvas_item;

const float x_movement_time = 1.0/6.0;
const float sawtooth_period = 0.15;
const float sine_speed = 2.0;
const float sine_freq = 5.0;
const float sine_amplitude = 0.2;
const float y_offset = 0.45;

uniform vec4 color : source_color;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.3, st.y);
}

float uv_sine(float pct) {
	return (sin(pct)/2.0)+0.5;
}

void fragment() {
	float sawtooth = mod(UV.x + TIME * x_movement_time, sawtooth_period);
	COLOR.a *= plot(UV,y_offset + uv_sine(UV.x * sine_freq + TIME * sine_speed) * sine_amplitude + sawtooth) * color.a;
	COLOR.rgb = color.rgb;
}
