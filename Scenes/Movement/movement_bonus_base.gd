@abstract
class_name MovementBonusBase
extends Node2D
# Base class for movement bonuses (literally does nothing here)

##### SIGNALS #####
@warning_ignore("UNUSED_SIGNAL")
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
@abstract func activate() -> void
