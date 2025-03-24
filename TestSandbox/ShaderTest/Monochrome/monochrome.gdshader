shader_type canvas_item;

const float TRESHOLD = 0.75;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool ACTIVE = false;

void fragment() {
	if(ACTIVE){
		vec4 screen_color = texture(SCREEN_TEXTURE,SCREEN_UV);
		vec3 step_color = step(1. - screen_color.rgb,vec3(TRESHOLD));
		COLOR.rgb = step_color;
	}
	else {
		COLOR.a = 0.0;
	}
}
