extends RefCounted
class_name StaticActionHandlerStrategy
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers {BASE, INPUT}

##### PUBLIC METHODS #####
static func get_handler(handler : handlers) -> ActionHandlerBase:
	match handler:
		handlers.BASE:
			return ActionHandlerBase.new()
		handlers.INPUT:
			return ActionHandlerInput.new()
	return ActionHandlerBase.new() # should never go here
