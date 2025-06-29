@tool
extends Node2D
# handles the particles for a destructible wall

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var tilemap := $"../.."
@onready var onready_paths := {
	"sparks": [
		$"Sparks",
		$"Sparks2"
	]
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_size()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Engine.is_editor_hint():
		_update_size()

##### PUBLIC METHODS #####
func set_color(color: Color) -> void:
	modulate = color

func toggle_emit(active: bool) -> void:
	for particle in onready_paths.sparks:
		particle.emitting = active

##### PROTECTED METHODS #####
func _update_size() -> void:
	var tilemap_rect = tilemap.get_used_rect()
	position = tilemap_rect.position * 64 + tilemap_rect.size * 64 / 2
	var tilemap_size = tilemap_rect.size * 64
	for particle in onready_paths.sparks:
		particle.process_material.emission_box_extents = Vector3(tilemap_size.x / 2.0, tilemap_size.y / 2.0, 0)
