extends RefCounted
class_name StaticMovementBonusHandler
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers {BASE, DASH}

##### PUBLIC METHODS #####
static func get_handler(handler : handlers) -> MovementBonusBase:
	match handler:
		handlers.BASE:
			return MovementBonusBase.new()
		handlers.DASH:
			return load("res://Scenes/Movement/MovementBonusDash/movement_bonus_dash.tscn").instantiate()
	return MovementBonusBase.new() # should never go here
