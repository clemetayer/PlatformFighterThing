extends Node2D
# handles the wall break particles

##### VARIABLES #####
#---- CONSTANTS -----
const PARTICLES_VELOCITY_BOUNDS := [0.25,2] # [min,max] 

##### PUBLIC METHODS #####
func init_particles(tilemap : TileMapLayer) -> void:
	for emitter in get_children():
		if emitter is GPUParticles2D:
			_fit_particles_to_tilemap(emitter, tilemap)
		_connect_explode_signal(tilemap)

##### PROTECTED METHODS #####
func _fit_particles_to_tilemap(emitter : GPUParticles2D, tilemap : TileMapLayer) -> void:
		var particles_process = emitter.process_material
		position = tilemap.get_used_rect().position * 64
		var tilemap_rect = tilemap.get_used_rect().size * 64
		emitter.visibility_rect = Rect2i(tilemap.get_used_rect().position * 64, tilemap.get_used_rect().size * 64).grow(4096)
		particles_process.emission_box_extents = Vector3i(tilemap_rect.x,tilemap_rect.y,0)
		var emit_direction = -tilemap.BOUNCE_BACK_DIRECTION
		particles_process.direction = Vector3(emit_direction.x, emit_direction.y,0) 

func _connect_explode_signal(tilemap : TileMapLayer) -> void:
	if not tilemap.is_connected("explode_fragments", _on_tilemap_explode):
		tilemap.connect("explode_fragments", _on_tilemap_explode)

##### SIGNAL MANAGEMENT #####
func _on_tilemap_explode(force : Vector2) -> void:
	for emitter in get_children():
		if emitter is GPUParticles2D:
			var particles_process = emitter.process_material
			particles_process.initial_velocity_min = PARTICLES_VELOCITY_BOUNDS[0] * force.length()
			particles_process.initial_velocity_max = PARTICLES_VELOCITY_BOUNDS[1] * force.length()
			emitter.emitting = true
