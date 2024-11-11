extends ActionHandlerBase
class_name ActionHandlerInput
# Action handler with inputs (key pressed, etc.) 

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_action_states[actions.JUMP] = _generic_get_action_state("jump")
	_action_states[actions.LEFT] = _generic_get_action_state("left")
	_action_states[actions.RIGHT] = _generic_get_action_state("right")
	_action_states[actions.UP] = _generic_get_action_state("up")
	_action_states[actions.DOWN] = _generic_get_action_state("down")
	_action_states[actions.FIRE] = _generic_get_action_state("fire")
	_action_states[actions.MOVEMENT_BONUS] = _generic_get_action_state("movement_bonus")
	_action_states[actions.PARRY] = _generic_get_action_state("parry")
	_action_states[actions.POWERUP] = _generic_get_action_state("powerup")

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
	DebugInterface.set_debug_text("jump",_action_states[actions.JUMP])
	DebugInterface.set_debug_text("left",_action_states[actions.LEFT])
	DebugInterface.set_debug_text("right",_action_states[actions.RIGHT])
	DebugInterface.set_debug_text("up",_action_states[actions.UP])
	DebugInterface.set_debug_text("down",_action_states[actions.DOWN])
	DebugInterface.set_debug_text("fire",_action_states[actions.FIRE])
	DebugInterface.set_debug_text("movement_bonus",_action_states[actions.MOVEMENT_BONUS])
	DebugInterface.set_debug_text("parry",_action_states[actions.PARRY])
	DebugInterface.set_debug_text("powerup",_action_states[actions.POWERUP])
