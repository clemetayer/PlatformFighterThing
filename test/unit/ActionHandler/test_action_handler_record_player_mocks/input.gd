extends Node
# workaround to mock inputs since GUT input mocks tend do be a bit weird

##### PUBLIC METHODS #####
func is_action_just_pressed(_action: String) -> bool:
	return false

func is_action_pressed(_action: String) -> bool:
	return false

func is_action_just_released(_action: String) -> bool:
	return false
