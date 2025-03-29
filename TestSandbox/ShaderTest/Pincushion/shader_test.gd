@tool
extends Node2D
# just to test the tween animation thing

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
@export var fake_bool: bool = false : set = _animate_shader

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# @onready var onready_var # Optionnal comment

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
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _animate_shader(_fake_bool) -> void:
	var tween = create_tween()
	tween.tween_method(_update_material_val,1.0,1.66,0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await tween.finished
	tween = create_tween()
	tween.tween_method(_update_material_val,1.5,0.33,0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await tween.finished
	tween = create_tween()
	tween.tween_method(_update_material_val,0.5,1.0,1.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _update_material_val(value : float) -> void:
	$PinCushion.material.set_shader_parameter("DISTORTION",value)
