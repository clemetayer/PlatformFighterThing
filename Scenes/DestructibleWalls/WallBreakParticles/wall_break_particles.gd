extends Node2D
# handles the wall break particles

##### VARIABLES #####
#---- CONSTANTS -----
const PARTICLES_VELOCITY_BOUNDS := [0.25,2] # [min,max] 

#---- EXPORTS -----
@export var TILEMAP_PATH : NodePath

#---- STANDARD -----
#==== PRIVATE ====
var _tilemap : TileMapLayer

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_tilemap = get_node_or_null(TILEMAP_PATH)
	if _tilemap != null:
		for emitter in get_children():
			if emitter is GPUParticles2D:
				_fit_particles_to_tilemap(emitter)
		_connect_explode_signal()
	else:
		Logger.error("Tilemap not set for %s" % name)

##### PROTECTED METHODS #####
func _fit_particles_to_tilemap(emitter : GPUParticles2D) -> void:
		var particles_process = emitter.process_material
		position = _tilemap.get_used_rect().position * 64
		var tilemap_rect = _tilemap.get_used_rect().size * 64
		emitter.visibility_rect = Rect2i(_tilemap.get_used_rect().position * 64, _tilemap.get_used_rect().size * 64).grow(4096)
		particles_process.emission_box_extents = Vector3i(tilemap_rect.x,tilemap_rect.y,0)
		var emit_direction = -_tilemap.BOUNCE_BACK_DIRECTION
		particles_process.direction = Vector3(emit_direction.x, emit_direction.y,0) 

func _connect_explode_signal() -> void:
	_tilemap.connect("explode_fragments", _on_tilemap_explode)

##### SIGNAL MANAGEMENT #####
func _on_tilemap_explode(force : Vector2) -> void:
	for emitter in get_children():
		if emitter is GPUParticles2D:
			var particles_process = emitter.process_material
			particles_process.initial_velocity_min = PARTICLES_VELOCITY_BOUNDS[0] * force.length()
			particles_process.initial_velocity_max = PARTICLES_VELOCITY_BOUNDS[1] * force.length()
			emitter.emitting = true
