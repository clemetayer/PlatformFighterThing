extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action_handler :ActionHandlerBase

##### SETUP #####
func before_each():
	action_handler = ActionHandlerBase.new()

##### TEARDOWN #####
func after_each():
	action_handler.free()

##### TESTS #####
func test_get_action_state_all_inactive():
	for action_idx in range(action_handler.actions.size()):
		assert_eq(action_handler.get_action_state(action_idx), action_handler.states.INACTIVE, "action idx %d has an invalid state" % action_idx)

func test_get_action_state_different_states():
	action_handler._action_states[action_handler.actions.JUMP] = action_handler.states.INACTIVE
	action_handler._action_states[action_handler.actions.UP] = action_handler.states.ACTIVE
	action_handler._action_states[action_handler.actions.DOWN] = action_handler.states.JUST_ACTIVE
	action_handler._action_states[action_handler.actions.LEFT] = action_handler.states.JUST_INACTIVE
	assert_eq(action_handler.get_action_state(action_handler.actions.JUMP), action_handler.states.INACTIVE)
	assert_eq(action_handler.get_action_state(action_handler.actions.UP), action_handler.states.ACTIVE)
	assert_eq(action_handler.get_action_state(action_handler.actions.DOWN), action_handler.states.JUST_ACTIVE)
	assert_eq(action_handler.get_action_state(action_handler.actions.LEFT), action_handler.states.JUST_INACTIVE)

func test_is_active():
	assert_true(ActionHandlerBase.is_active(ActionHandlerBase.states.ACTIVE))
	assert_true(ActionHandlerBase.is_active(ActionHandlerBase.states.JUST_ACTIVE))
	assert_false(ActionHandlerBase.is_active(ActionHandlerBase.states.INACTIVE))
	assert_false(ActionHandlerBase.is_active(ActionHandlerBase.states.JUST_INACTIVE))

func test_is_just_active():
	assert_false(ActionHandlerBase.is_just_active(ActionHandlerBase.states.ACTIVE))
	assert_true(ActionHandlerBase.is_just_active(ActionHandlerBase.states.JUST_ACTIVE))
	assert_false(ActionHandlerBase.is_just_active(ActionHandlerBase.states.INACTIVE))
	assert_false(ActionHandlerBase.is_just_active(ActionHandlerBase.states.JUST_INACTIVE))

func test_is_just_inactive():
	assert_false(ActionHandlerBase.is_just_inactive(ActionHandlerBase.states.ACTIVE))
	assert_false(ActionHandlerBase.is_just_inactive(ActionHandlerBase.states.JUST_ACTIVE))
	assert_false(ActionHandlerBase.is_just_inactive(ActionHandlerBase.states.INACTIVE))
	assert_true(ActionHandlerBase.is_just_inactive(ActionHandlerBase.states.JUST_INACTIVE))
