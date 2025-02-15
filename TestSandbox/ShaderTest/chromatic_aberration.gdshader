shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float strength : hint_range(0.0,20.0) = 20.0;

void fragment()
{
	vec2 centered_uv = vec2(0.5) - UV;
	float radius = length(centered_uv)*2.0;
	float angle = atan(centered_uv.y,centered_uv.x);
	vec2 r_offset = vec2(cos(angle),sin(angle)) * radius * strength * SCREEN_PIXEL_SIZE;
	vec2 g_offset = vec2(cos(angle),sin(angle)) * radius * strength * SCREEN_PIXEL_SIZE;
	COLOR = vec4(
		texture(SCREEN_TEXTURE,SCREEN_UV+r_offset).r,
		texture(SCREEN_TEXTURE,SCREEN_UV).g,
		texture(SCREEN_TEXTURE,SCREEN_UV-g_offset).b,
		1.0
	);
}