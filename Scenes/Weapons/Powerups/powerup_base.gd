extends Node2D
class_name PowerupBase
# Base class for the powerups

##### SIGNALS #####
signal value_updated(value)

##### PUBLIC METHODS #####
# to be overrided by children classes
func use() -> void:
    pass
