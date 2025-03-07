shader_type canvas_item;

const float EDGE_THICKNESS = 2.0;
const float VORONOI_COLUMNS = 10.0;
const float VORONOI_ROWS = 10.0;

uniform vec2 fract_size;
uniform float destruction_amount : hint_range(0.0,1.0) = 0.0;

// from https://godotshaders.com/snippet/random-value/
vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

// from https://godotshaders.com/snippet/voronoi/
vec2 voronoi(vec2 uv, float columns, float rows) {

	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));

	float minimum_dist = 1.0;
	vec2 minimum_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);

			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);

			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point;
			}
		}
	}
	return minimum_point;
}

void fragment() {
	vec2 fract_uv = fract(UV * fract_size / 10.0);

	vec2 voronoi_point = voronoi(fract_uv, VORONOI_COLUMNS, VORONOI_ROWS);

    // Calculate the Voronoi point for neighboring pixels using derivatives
    vec2 voronoi_point_right = voronoi(fract_uv + vec2(dFdx(fract_uv.x), 0.0) * EDGE_THICKNESS, VORONOI_COLUMNS, VORONOI_ROWS);
    vec2 voronoi_point_down = voronoi(fract_uv + vec2(0.0, dFdy(fract_uv.y)) * EDGE_THICKNESS, VORONOI_COLUMNS, VORONOI_ROWS);

    // Detect borders by checking if the Voronoi point changes
    bool is_border = (voronoi_point != voronoi_point_right) || (voronoi_point != voronoi_point_down);
	
	// To show the edge or not
	bool is_above_destruction_level = max(voronoi_point.x,voronoi_point_down.x) >= 1.0 - destruction_amount;

    // Output color based on whether it's a border or not
	if(is_border && is_above_destruction_level) {
		COLOR = vec4(1.0);
	}
	else {
		COLOR = vec4(0.0);
	}
}
