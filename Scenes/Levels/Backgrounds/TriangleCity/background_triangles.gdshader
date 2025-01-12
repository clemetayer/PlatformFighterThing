shader_type canvas_item;

uniform sampler2D gradient;
uniform vec4 drop_color : source_color;

uniform float max_size = 0.002;
uniform float ss_e = 0.001; // smoothstep epsilon
uniform float trail_epsilon = 0.3; // which givesthe "trail" effect
uniform int number_of_squares = 32;
uniform float max_velocity = 0.75;
uniform float min_velocity = 0.1;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float smoothstep_interval(float point, float pos_1, float pos_2){
	return smoothstep(pos_1 - ss_e, pos_1 + ss_e, point) - smoothstep(pos_2 - ss_e, pos_2 + ss_e, point);
}

float square_stroke(vec2 uv, float rand, vec2 pos){
	float square = smoothstep_interval(uv.x,pos.x, pos.x + max_size) * smoothstep_interval(uv.y,pos.y, pos.y + max_size);
	if(pos.x + max_size >= 1.0){
		square += smoothstep_interval(uv.x, 0.0, mod(pos.x + max_size,1.0)) * smoothstep_interval(uv.y, pos.y, pos.y + max_size);
	}
	if(pos.y + max_size >= 1.0){
		square += smoothstep_interval(uv.x, pos.x, pos.x + max_size) * smoothstep_interval(uv.y, 0.0, mod(pos.y + max_size,1.0));
	}
	return square;
}

// the "trail" part of the effect
float trail(vec2 uv, float rand, vec2 pos){
	float trail = smoothstep_interval(uv.x,pos.x, pos.x + max_size) * (smoothstep(pos.y - trail_epsilon, pos.y, uv.y) - smoothstep(pos.y + max_size, pos.y + max_size, uv.y));
	if(pos.x + max_size >= 1.0){
		trail += smoothstep_interval(uv.x, 0.0, mod(pos.x + max_size,1.0)) * (smoothstep(pos.y - trail_epsilon, pos.y, uv.y) - smoothstep(pos.y + max_size, pos.y + max_size, uv.y));
	}
	if(pos.y + max_size >= 1.0){
		trail += smoothstep_interval(uv.x, pos.x, pos.x + max_size) * (smoothstep(0.0 - trail_epsilon, 0.0, uv.y) - smoothstep(mod(pos.y + max_size,1.0), mod(pos.y + max_size,1.0), uv.y));
	}
	if(pos.y - trail_epsilon <= 0.0){
		trail += smoothstep_interval(uv.x, pos.x, pos.x + max_size) * (smoothstep(mod(pos.y - trail_epsilon, 1.0), 1.0, uv.y));
	}
	return trail;
}

void fragment() {
	vec4 back_color = texture(gradient, vec2(UV.y,1));
	for(int i = 0; i < number_of_squares; i++){
		float rand_x = random(vec2(float(i)/float(number_of_squares)));
		float rand_y = random(vec2(float(i)/float(number_of_squares),0.0));
		float rand_vel = max(min_velocity,random(vec2(0.0,float(i)/float(number_of_squares))) * max_velocity);
		vec2 pos = vec2(0);
		pos.x = rand_y;
		pos.y = mod(TIME * rand_vel, 1.0) ;
		vec4 square = drop_color * trail(UV, rand_x, pos);
		back_color += square;
	}
	COLOR =  vec4(back_color.rgb,COLOR.a);
}
