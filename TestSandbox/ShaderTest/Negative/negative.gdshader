shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool ACTIVE = false;

void fragment() {
	if(ACTIVE){
		vec4 color = texture(SCREEN_TEXTURE,SCREEN_UV);
		COLOR.rgb = 1. - color.rgb;
	}
	else {
		COLOR.a = 0.0;
	}
}
