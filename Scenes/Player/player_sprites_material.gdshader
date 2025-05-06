shader_type canvas_item;

uniform float spawn_animation_progress : hint_range(-0.30,1.0) = 1.0;

const float SPAWN_TRANSPARENCY_SMOOTHSTEP = 0.15;

void fragment() {
	COLOR.a *= smoothstep(UV.y - SPAWN_TRANSPARENCY_SMOOTHSTEP, UV.y + SPAWN_TRANSPARENCY_SMOOTHSTEP, spawn_animation_progress + SPAWN_TRANSPARENCY_SMOOTHSTEP);
}
