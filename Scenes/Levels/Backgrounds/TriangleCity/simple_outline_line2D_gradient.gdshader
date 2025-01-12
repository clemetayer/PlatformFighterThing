shader_type canvas_item;

uniform sampler2D gradient;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 gradient_uv_pos = vec2(sin((UV.x * UV.y + TIME)),0.0);
	COLOR.rgb = texture(gradient, gradient_uv_pos).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
