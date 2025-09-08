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
var _fired_projectile

#==== ONREADY ====
@onready var onready_paths := {
	"player": $"Player",
	"fire_position_node": $"FirePosition" 
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
func get_fire_position() -> Vector2:
	return onready_paths.fire_position_node.global_position

func get_player_config(_id : int) -> PlayerConfig:
	return load("res://test/integration/common/default_player_config.tres")

func get_player() -> Node2D:
	return onready_paths.player

func get_fired_projectile():
	return _fired_projectile

func is_parrying() -> bool:
	return onready_paths.player.onready_paths_node.parry_area._parrying

func is_parry_lockout() -> bool:
	return not onready_paths.player.onready_paths_node.parry_area._can_parry

func toggle_parry(active : bool) -> void:
	onready_paths.player.onready_paths_node.parry_area.toggle_parry(active)

func fire_projectile(projectile_scene) -> void:
	_fired_projectile = projectile_scene
	add_child(_fired_projectile)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
