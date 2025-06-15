extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action_handler : ActionHandlerInput

##### SETUP #####
func before_each():
	action_handler = ActionHandlerInput.new()

##### TEARDOWN #####
func after_each():
	action_handler.free()

##### TESTS #####
func test_process_updates_action_states():
	# given
	var input_sender = InputSender.new(Input)
	input_sender.action_down("jump").action_down("left").wait_frames(1)
	await input_sender.idle
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.RIGHT], ActionHandlerBase.states.INACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.UP], ActionHandlerBase.states.INACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.DOWN], ActionHandlerBase.states.INACTIVE)
	# clean up
	input_sender.release_all()
	input_sender.clear()

func test_process_updates_action_states_when_held():
	# given
	var input_sender = InputSender.new(Input)
	input_sender.action_down("jump").action_down("left").wait_frames(2)
	await input_sender.idle
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.ACTIVE)
	# clean up
	input_sender.release_all()
	input_sender.clear()

func test_process_updates_action_states_when_released():
	# given
	var input_sender = InputSender.new(Input)
	input_sender.action_down("jump").action_down("left").wait_frames(1)
	await input_sender.idle
	input_sender.action_up("jump").action_up("left").wait_frames(1)
	await input_sender.idle
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.JUST_INACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.JUST_INACTIVE)
	# clean up
	input_sender.release_all()
	input_sender.clear()

func test_process_updates_all_input_actions():
	# given
	var input_sender = InputSender.new(Input)
	input_sender.action_down("jump")
	input_sender.action_down("left")
	input_sender.action_down("right")
	input_sender.action_down("up")
	input_sender.action_down("down")
	input_sender.action_down("fire")
	input_sender.action_down("movement_bonus")
	input_sender.action_down("parry")
	input_sender.action_down("powerup")
	input_sender.wait_frames(1)
	await input_sender.idle
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.RIGHT], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.UP], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.DOWN], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.FIRE], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.MOVEMENT_BONUS], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.PARRY], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.POWERUP], ActionHandlerBase.states.JUST_ACTIVE)
	# clean up
	input_sender.release_all()
	input_sender.clear()

func test_process_sets_relative_aim_position():
	# given
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler.relative_aim_position, action_handler.get_global_mouse_position() - action_handler.global_position)
