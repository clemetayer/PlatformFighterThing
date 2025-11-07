shader_type canvas_item;
render_mode world_vertex_coords;

const float max_distance = 10.0;

uniform vec2 test_pos=vec2(0.0);

void vertex()
{
	float test = distance(VERTEX, test_pos)/ 500.0;
	COLOR.rgb = vec3(test, 0.0, 0.0);
}