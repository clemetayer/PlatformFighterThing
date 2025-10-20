extends RefCounted
class_name StaticMovementBonusHandler
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers {DASH}

##### PUBLIC METHODS #####
static func get_handler(handler : handlers) -> MovementBonusBase:
	match handler:
		handlers.DASH:
			return load("res://Scenes/Movement/MovementBonusDash/movement_bonus_dash.tscn").instantiate()
	GSLogger.error("error getting the movement handler %s, using the default dash as a failsafe." % handler)
	return load("res://Scenes/Movement/MovementBonusDash/movement_bonus_dash.tscn").instantiate() # should never go here
