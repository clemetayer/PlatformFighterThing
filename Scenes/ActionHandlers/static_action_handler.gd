extends RefCounted

class_name StaticActionHandler
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers { INPUT, RECORD, GROGGY_GARY }


##### PUBLIC METHODS #####
static func get_handler(handler: handlers) -> ActionHandlerBase:
	match handler:
		handlers.INPUT:
			return ActionHandlerInput.new()
		handlers.RECORD:
			return ActionHandlerRecord.new()
		handlers.GROGGY_GARY:
			return load("res://Scenes/AI/Profiles/GroggyGary/groggy_gary_action_handler.tscn").instantiate()
	GSLogger.error("error getting the action handler %s, using input as a failsafe" % handler)
	return ActionHandlerInput.new() # should never go here
