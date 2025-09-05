extends Node
class_name IntegrodotActionExecutor
# Interface to extend to replay actions for integration testing

##### SIGNALS #####
signal record_action_triggered(action_name : String, value)

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const INTEGRODOT_ACTION_EXECUTOR_GROUP_NAME := "integrodot_action_executor"

#---- EXPORTS -----
@export var ID : String

#---- STANDARD -----
#==== PUBLIC ====

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# @onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	add_to_group(INTEGRODOT_ACTION_EXECUTOR_GROUP_NAME)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
static func get_executor(tree: SceneTree) -> Array:
	return tree.get_nodes_in_group(INTEGRODOT_ACTION_EXECUTOR_GROUP_NAME)

static func get_executor_with_id(tree: SceneTree, id : String) -> Array:
	return get_executor(tree).filter(func(node): return node.ID == id)

# To be overriden by children classes
func replay_action(action : String, value) -> void:
	pass

func record_action(action : String, value) -> void:
	emit_signal("record_action_triggered", action, value)

func connect_record_action(method : Callable) -> void:
	connect("record_action_triggered", method)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

