@tool
extends Area2D
# Area to detect the collision with the player

##### VARIABLES #####
#---- CONSTANTS -----
const OFFSET := 32 # in pixels

#---- STANDARD -----
#==== ONREADY ====
@onready var tilemap := $"../.."
@onready var collision_shape := $"CollisionShape2D"

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_size()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Engine.is_editor_hint():
		_update_size()

##### PROTECTED METHODS #####
func _update_size() -> void:
	var tilemap_rect = tilemap.get_used_rect()
	position = tilemap_rect.position * 64 + tilemap_rect.size * 64 / 2
	collision_shape.shape.size = tilemap_rect.size * 64 + Vector2i.ONE * OFFSET
