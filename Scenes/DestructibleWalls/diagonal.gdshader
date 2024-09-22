shader_type canvas_item;

uniform sampler2D moving_tex;
uniform vec2 fract_size;
uniform float speed = 2.0;


void fragment() {
	vec2 fract_uv = fract(UV * fract_size);
	vec2 offset_uv = vec2(mod(fract_uv.x + TIME * speed, 1.0),fract_uv.y);
	vec4 tex = texture(moving_tex,offset_uv);
	COLOR.a *= tex.a;
}