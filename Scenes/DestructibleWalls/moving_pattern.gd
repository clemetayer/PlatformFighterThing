@tool
extends ColorRect
# utility script to automatically control the size of the moving pattern 

##### VARIABLES #####
#---- STANDARD -----

#==== PRIVATE ====
var _engine := Engine

#==== ONREADY ====
@onready var tilemap := $"../.."

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_size()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if _engine.is_editor_hint():
		_update_size()

##### PROTECTED METHODS #####
func _update_size() -> void:
	var tilemap_rect = tilemap.get_used_rect()
	size = tilemap_rect.size * 64
	position = tilemap_rect.position * 64
	material.set_shader_parameter("fract_size",tilemap_rect.size)
