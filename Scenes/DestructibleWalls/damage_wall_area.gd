@tool
extends Area2D
# Area to detect the collision with the player

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const OFFSET := 32 # in pixels

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var tilemap := $".."
@onready var collision_shape := $"CollisionShape2D"

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_size()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Engine.is_editor_hint():
		_update_size()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _update_size() -> void:
	var tilemap_rect = tilemap.get_used_rect()
	position = tilemap_rect.position * 64 + tilemap_rect.size * 64 / 2
	collision_shape.shape.size = tilemap_rect.size * 64 + Vector2i.ONE * OFFSET

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
