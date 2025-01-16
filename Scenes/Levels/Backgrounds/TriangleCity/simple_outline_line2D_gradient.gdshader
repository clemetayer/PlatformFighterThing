shader_type canvas_item;

uniform sampler2D gradient;
uniform float speed : hint_range(0.0,50.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 gradient_uv_pos = vec2((sin((UV.y + TIME * speed))/2.0)+0.5,0.0);
	COLOR.rgb = texture(gradient, gradient_uv_pos).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
