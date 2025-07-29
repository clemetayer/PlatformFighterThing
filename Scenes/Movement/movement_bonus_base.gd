extends Node2D
class_name MovementBonusBase
# Base class for movement bonuses (literally does nothing here)

##### SIGNALS #####
signal value_updated(value)

##### VARIABLES #####
#---- EXPORTS -----
@export var handler_type : StaticMovementBonusHandler.handlers

#---- STANDARD -----
#==== PUBLIC ====
var state := ActionHandlerBase.states.INACTIVE
var player : Node2D = null
var active := false

##### PUBLIC METHODS #####
@rpc("authority", "call_local", "reliable")
func activate() -> void:
	pass 
