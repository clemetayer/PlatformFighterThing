extends ActionHandlerBase
class_name ActionHandlerInput
# Action handler with inputs (key pressed, etc.) 

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	jump = _generic_get_action_state("jump")
	left = _generic_get_action_state("left")
	right = _generic_get_action_state("right")
	up = _generic_get_action_state("up")
	down = _generic_get_action_state("down")
	fire = _generic_get_action_state("fire")

##### PROTECTED METHODS #####
func _generic_get_action_state(input_action : String) -> states:
	if Input.is_action_just_pressed(input_action):
		return states.JUST_ACTIVE
	elif Input.is_action_pressed(input_action):
		return states.ACTIVE
	elif Input.is_action_just_released(input_action):
		return states.JUST_INACTIVE
	return states.INACTIVE

func _debug_show_states() -> void:
	DebugInterface.set_debug_text("jump",jump)
	DebugInterface.set_debug_text("left",left)
	DebugInterface.set_debug_text("right",right)
	DebugInterface.set_debug_text("up",up)
	DebugInterface.set_debug_text("down",down)
	DebugInterface.set_debug_text("fire",fire)
