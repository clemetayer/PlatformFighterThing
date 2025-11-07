shader_type canvas_item;

const float max_distance = 0.1;
const float warning_blink_speed = 15.0;
const float warning_fract_amount = 20.0;

uniform vec2 players_uv_positions[8];
uniform vec2 corner_position;
uniform sampler2D warning_texture;
uniform vec3 colors_gradient[2];
uniform vec2 sprite_scale;

float get_players_distance_alpha(vec2 uv) {
	float alpha = 0.0;
	for(int player_idx=0; player_idx < players_uv_positions.length(); player_idx++) {
		vec2 player_position = players_uv_positions[player_idx];
		if(player_position.x <= 1.0 && player_position.y <= 1.0) { // HACK : to control the amount of players, by default, the have a UV_POSITION > 1.0
			float dist = distance(players_uv_positions[player_idx], uv);
			if(dist<=max_distance) {
				alpha += 1.0 - (dist / max_distance);
			}
		}
	}
	return alpha;
}

float get_warning_alpha(vec2 uv) {
	vec2 frag_uv = fract(uv * warning_fract_amount * sprite_scale);
	return texture(warning_texture,frag_uv).a;
}

bool is_inside_bounds(vec2 uv) {
	return uv.x >= corner_position.x
		&& uv.y >= corner_position.y
		&& uv.x <= 1.0 - corner_position.x
		&& uv.y <= 1.0 - corner_position.y;
}

float get_interior_bounds_alpha(vec2 uv) {
	if(is_inside_bounds(uv)) {
		return 0.0;
	}
	return 1.0;
}

void fragment() {
	// COLOR.rgb = vec3(UV.x, UV.y, 0.0); // for debugging purposes
	// COLOR.a = 1.0 * get_warning_alpha(UV) * get_interior_bounds_alpha(UV);
	// COLOR.a = get_players_distance_alpha(UV) * get_warning_alpha(UV);
	COLOR.a = get_players_distance_alpha(UV) * get_warning_alpha(UV) * get_interior_bounds_alpha(UV);
	COLOR.rgb = mix(colors_gradient[0], colors_gradient[1], sin(UV.y + TIME * warning_blink_speed));
}