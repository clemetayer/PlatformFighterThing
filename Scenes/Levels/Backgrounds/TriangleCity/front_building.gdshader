shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	vec4 back_color = texture(gradient, vec2(UV.y,1));
	COLOR = vec4(back_color.rgb,COLOR.a);
}