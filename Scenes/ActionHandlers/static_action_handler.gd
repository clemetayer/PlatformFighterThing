extends RefCounted

class_name StaticActionHandler
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers { INPUT, RECORD, GROGGY_GARY, SCARED_SARAH, CONFUSED_CHARLIE }


##### PUBLIC METHODS #####
static func get_handler(handler: handlers) -> ActionHandlerBase:
	match handler:
		handlers.INPUT:
			return ActionHandlerInput.new()
		handlers.RECORD:
			return ActionHandlerRecord.new()
		handlers.GROGGY_GARY:
			return load("res://Scenes/AI/Profiles/GroggyGary/groggy_gary_action_handler.tscn").instantiate()
		handlers.SCARED_SARAH:
			return load("res://Scenes/AI/Profiles/ScaredSarah/scared_sarah_action_handler.tscn").instantiate()
		handlers.CONFUSED_CHARLIE:
			return load("res://Scenes/AI/Profiles/ConfusedCharlie/confused_charlie_action_handler.tscn").instantiate()
	GSLogger.error("error getting the action handler %s, using input as a failsafe" % handler)
	return ActionHandlerInput.new() # should never go here
