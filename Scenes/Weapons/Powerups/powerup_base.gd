extends Node2D
class_name PowerupBase
# Base class for the powerups

##### SIGNALS #####
@warning_ignore("UNUSED_SIGNAL")
signal value_updated(value)

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var active := false

##### PUBLIC METHODS #####
# to be overrided by children classes
@rpc("authority", "call_local", "reliable")
func use() -> void:
    pass
