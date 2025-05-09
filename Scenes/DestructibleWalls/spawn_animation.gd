extends Node
# Handles the spawn entrance animation for the destructible wall

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_OFFSET := 500
const ANIMATION_TIME := 1 #s

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _animation_tween : Tween

#==== ONREADY ====
@onready var root := get_parent()
@onready var onready_paths := {}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

##### PUBLIC METHODS #####
func play_spawn_animation(direction : Vector2) -> void:
	root.position = -direction * BASE_OFFSET
	if _animation_tween != null:
		_animation_tween.kill()
	_animation_tween = create_tween()
	_animation_tween.tween_property(root, "position", Vector2.ZERO, ANIMATION_TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await _animation_tween.finished


##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
