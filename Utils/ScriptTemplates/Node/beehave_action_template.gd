# meta-default: true
# meta-description: Base template for beehave action leaves
# @tool
extends ActionLeaf
# class_name Class
# docstring

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
# var _private_var # Optionnal comment

#==== ONREADY ====
# @onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func tick(actor: Node, _blackboard: Blackboard) -> int:
	return SUCCESS

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass
