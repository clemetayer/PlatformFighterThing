shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform float DISTORTION : hint_range(0.0,2.0) = 1.0;

// Inspired from https://godotshaders.com/shader/crt-with-variable-fisheye/
// But with just the fisheye, not the crt effect
vec2 fisheye(vec2 uv) {
	vec2 distance_from_center = uv - 0.5;
	float radius = length(distance_from_center);
	float theta = atan(distance_from_center.y, distance_from_center.x);
	float rf = pow(radius, DISTORTION) / pow(0.5, DISTORTION - 1.0);
	return vec2(0.5) + rf * normalize(distance_from_center);
}

void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
	COLOR = texture(SCREEN_TEXTURE,fisheye(uv));
}
