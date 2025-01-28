# tool
extends ParallaxBackground
# class_name Class
# Attempts to decorellate the camera movement from the parallax background movement

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

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
	# These lines will disconnect the parallax movement from the camera movement
	for group in get_groups():
		if group.begins_with("__cameras"):
			remove_from_group(group)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	# Move the parallax manually if right is pressed
	if(Input.is_action_pressed("right")):
		scroll_base_offset.x += delta * 200.0

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
