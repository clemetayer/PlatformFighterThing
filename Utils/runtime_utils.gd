extends Node
# Runtime utilitary functions

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const GAME_ROOT_GROUP_NAME := "game_root"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var is_offline_game := true 

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Checks if the current instance is the multiplayer authority
func is_authority() -> bool:
	return get_multiplayer_authority() == multiplayer.get_unique_id() or is_offline_game

# Returns the game root or null if it does not exists
func get_game_root() -> Node:
	return get_tree().get_first_node_in_group(GAME_ROOT_GROUP_NAME)

# sets the general time scale of the engine (including the audio)
func set_time_scale(scale : float) -> void:
	Engine.time_scale = scale
	AudioServer.playback_speed_scale = scale

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
