extends RefCounted
class_name StaticUtils
# contains various static elements common to the entire game (enums, const, static functions, etc.)

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum GAME_TYPES {OFFLINE, HOST, CLIENT}

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

##### PUBLIC METHODS #####
# https://easings.net/#easeOutCubic
static func cubic_ease_out(x : float) -> float:
	return min(1.0, abs(1 - pow(1 - x, 3)))

static func map_if_exists(data : Dictionary, key, object, variable_name : String) -> void:
	if data.has(key):
		if variable_name in object:
			object.set(variable_name, data[key])
		else:
			Logger.warn("object %s does not contain the variable %s, at %s" % [object, variable_name, get_stack()])
	else:
		Logger.warn("%s does not contain the key %s, at %s" % [data, key, get_stack()])

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
