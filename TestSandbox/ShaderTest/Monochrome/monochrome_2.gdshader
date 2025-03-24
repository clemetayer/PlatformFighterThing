shader_type canvas_item;

const float TRESHOLD = 0.25;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool ACTIVE = false;

void fragment() {
	if(ACTIVE) {
		vec4 screen_color = texture(SCREEN_TEXTURE,SCREEN_UV);
		float avg = (screen_color.r + screen_color.g + screen_color.b) / 3.0;
		COLOR.rgb = vec3(step(avg,TRESHOLD));
	}
	else {
		COLOR.a = 0.0;
	}
}