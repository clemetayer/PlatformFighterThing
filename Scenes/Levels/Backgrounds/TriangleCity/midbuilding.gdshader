shader_type canvas_item;

uniform vec4 back_color : source_color;
uniform sampler2D window_texture;
uniform sampler2D windows_gradient;
uniform int window_grid_size = 33;
uniform float window_seed : hint_range(0.1,10.0) =  0.1;
uniform float window_draw_chance : hint_range(0.0,1.0) = 0.8;
uniform float window_gradient_speed : hint_range(0.0,50.0) = 1.0;

const float outline_detection_step_angle = PI/3.0; // divide more if the outline is not detected correctly

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float draw_texture(sampler2D tex, vec2 uv) {
	float grid_size_float = float(window_grid_size);
	vec2 fract_uv = fract(uv * vec2(grid_size_float));
	vec2 ran_step_uv = vec2(float(int(uv.x * grid_size_float))/grid_size_float, float(int(uv.y * grid_size_float))/grid_size_float);
	if(random(ran_step_uv * window_seed) > window_draw_chance){
		return texture(tex,fract_uv).a;
	}
	return 0.0;
}

void fragment() {
	COLOR = vec4(back_color.rgb, COLOR.a * back_color.a);
	// draw windows
	if(draw_texture(window_texture,UV) > 0.0) {
		vec2 gradient_uv_pos = vec2(sin((UV.x * UV.y + TIME) * window_gradient_speed),0.0);
		COLOR.rgb = texture(windows_gradient, gradient_uv_pos).rgb;
	}
}