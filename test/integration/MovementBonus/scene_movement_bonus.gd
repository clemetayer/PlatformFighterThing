extends Node2D
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _player_config : PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"player_spawn_position_node": $"PlayerSpawnPosition"
}

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
func get_player_spawn_position() -> Vector2:
	return onready_paths.player_spawn_position_node.global_position

func get_player_config(_id : int) -> PlayerConfig:
	return _player_config

func set_player_config(player_config : PlayerConfig) -> void:
	_player_config = player_config

func add_player(player: Node2D) -> void:
	player.global_position = get_player_spawn_position()
	add_child(player)

func disable_truce() -> void:
	for player in get_tree().get_nodes_in_group("player"):
		player.toggle_truce(false)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
