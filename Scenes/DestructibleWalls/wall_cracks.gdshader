shader_type canvas_item;

uniform sampler2D cracks_tex;
uniform vec2 fract_size;
uniform float destruction_amount : hint_range(0.0,1.0) = 0.0;

void fragment() {
	vec2 fract_uv = fract(UV * fract_size / 3.0);
	vec4 tex = texture(cracks_tex, fract_uv);
	if(1.0 - tex.r >= 1.0 - destruction_amount){
		COLOR.a = tex.a;
	}
	else{
		COLOR.a = 0.0;
	}
}
