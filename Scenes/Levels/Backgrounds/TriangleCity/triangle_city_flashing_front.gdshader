shader_type canvas_item;

uniform sampler2D outline_texture;
uniform sampler2D fill_texture;
uniform sampler2D gradient;

const float number_of_diagonals = 5.0;
const float diagonal_size = 0.06;
const float diagonal_speed = 0.9;

vec2 fract_uv_symetrical(vec2 uv) {
	vec2 fract_uv = fract(uv * 2.0);
	if(uv.x > 0.5) {
		fract_uv.x = 1.0 - fract_uv.x;
	}
	if(uv.y > 0.5) {
		fract_uv.y = 1.0 - fract_uv.y;
	}
	return fract_uv;
}

float plot_diagonal_fills(vec2 uv) {
	float diag_real_size = 1.0 - diagonal_size;
	float moving_x_uv = mod(uv.x - TIME * diagonal_speed,1.0);
	float moving_diagonals = abs(mod(number_of_diagonals * moving_x_uv,1.0) - uv.y);
	return  step(diag_real_size,1.0 - moving_diagonals);
}

float plot_outline(vec2 uv) {
	return texture(outline_texture,uv).a;
}

void fragment() {
	vec2 fract_uv = fract_uv_symetrical(UV);
	COLOR.rgb = texture(gradient, vec2(UV.y,0.0)).rgb;
	float pattern = plot_outline(fract_uv) + plot_diagonal_fills(fract_uv) * texture(fill_texture,fract_uv).a;
	COLOR.a = min(1.0,pattern);
}
