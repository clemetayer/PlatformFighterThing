extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action_handler : ActionHandlerRecord

##### SETUP #####
func before_each():
	action_handler = ActionHandlerRecord.new()

##### TEARDOWN #####
func after_each():
	action_handler.free()

##### TESTS #####
func test_start_record():
	# given
	# when
	action_handler._start_record()
	# then
	assert_not_null(action_handler.record)
	assert_true(action_handler._recording)
	assert_eq(action_handler._current_frame_time, 0.0)
	assert_eq(action_handler._current_frame_index, 0)

func test_stop_record():
	# given
	action_handler._recording = true
	action_handler._current_frame_time = 10.5
	action_handler._current_frame_index = 350
	action_handler.record = InputRecord.new()
	# when
	action_handler._stop_recording()
	# then
	assert_false(action_handler._recording)
	assert_eq(action_handler.record.final_frame_time, 10.5)
	assert_eq(action_handler._current_frame_time, 0.0)
	assert_eq(action_handler._current_frame_index, 0)

func test_record_frame():
	# given
	action_handler.record = InputRecord.new()
	action_handler._recording = true
	action_handler._action_states[ActionHandlerBase.actions.JUMP] = ActionHandlerBase.states.ACTIVE
	action_handler._action_states[ActionHandlerBase.actions.LEFT] = ActionHandlerBase.states.JUST_ACTIVE
	action_handler._action_states[ActionHandlerBase.actions.DOWN] = ActionHandlerBase.states.JUST_INACTIVE
	action_handler.relative_aim_position = Vector2(125.2, -252.5)
	action_handler._current_frame_time = 0.25
	# when
	action_handler._record_frame()
	# then
	assert_eq(action_handler.record.inputs.size(),1)
	var recorded_input = action_handler.record.inputs[0]
	assert_eq(recorded_input.frame_time,0.25)
	assert_eq(recorded_input.relative_aim_position,Vector2(125.2, -252.5))
	assert_eq(recorded_input.inputs.size(),3)
	var checked_inputs_cnt = 0
	for input in recorded_input.inputs:
		if input.action == ActionHandlerBase.actions.JUMP:
			assert_eq(input.state, ActionHandlerBase.states.ACTIVE)
			checked_inputs_cnt += 1
		elif input.action == ActionHandlerBase.actions.LEFT:
			assert_eq(input.state, ActionHandlerBase.states.JUST_ACTIVE)
			checked_inputs_cnt += 1
		elif input.action == ActionHandlerBase.actions.DOWN:
			assert_eq(input.state, ActionHandlerBase.states.JUST_INACTIVE)
			checked_inputs_cnt += 1
	assert_eq(checked_inputs_cnt,3)

func test_listen_to_inputs_just_active():
	# given
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(false)
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	stub(input, "is_action_just_pressed").when_passed("jump").to_return(true)
	action_handler._input = input
	# when
	action_handler._listen_to_inputs()
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.UP], ActionHandlerBase.states.INACTIVE)
	assert_eq(action_handler.relative_aim_position, action_handler.get_global_mouse_position() - action_handler.global_position) 

func test_listen_to_inputs_active():
	# given
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(false)
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	stub(input, "is_action_pressed").when_passed("jump").to_return(true)
	action_handler._input = input
	# when
	action_handler._listen_to_inputs()
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.UP], ActionHandlerBase.states.INACTIVE)
	assert_eq(action_handler.relative_aim_position, action_handler.get_global_mouse_position() - action_handler.global_position) 

func test_listen_to_inputs_just_inactive():
	# given
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(false)
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	stub(input, "is_action_just_released").when_passed("jump").to_return(true)
	action_handler._input = input
	# when
	action_handler._listen_to_inputs()
	# then
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.JUST_INACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.UP], ActionHandlerBase.states.INACTIVE)
	assert_eq(action_handler.relative_aim_position, action_handler.get_global_mouse_position() - action_handler.global_position) 

func test_find_closest_frame():
	# given
	action_handler.record = InputRecord.new()
	var frame1 = FrameInputRecord.new()
	frame1.frame_time = 0.1
	var frame2 = FrameInputRecord.new()
	frame2.frame_time = 0.2
	var frame3 = FrameInputRecord.new()
	frame3.frame_time = 0.3
	action_handler.record.inputs = [frame1, frame2, frame3]
	action_handler.record.final_frame_time = 0.3
	action_handler._current_frame_time = 0.15
	action_handler._current_frame_index = 0
	# when
	var result = action_handler._find_closest_frame()
	# then
	assert_eq(result, frame2)
	assert_eq(action_handler._current_frame_index, 1)

func test_find_closest_frame_loop():
	# given
	action_handler.record = InputRecord.new()
	var frame1 = FrameInputRecord.new()
	frame1.frame_time = 0.1
	var frame2 = FrameInputRecord.new()
	frame2.frame_time = 0.2
	var frame3 = FrameInputRecord.new()
	frame3.frame_time = 0.3
	action_handler.record.inputs = [frame1, frame2, frame3]
	action_handler.record.final_frame_time = 0.3
	action_handler._current_frame_index = 0	
	action_handler._current_frame_time = 0.4
	action_handler.loop = true
	# when
	var result = action_handler._find_closest_frame()
	# then
	assert_eq(result, frame1)
	assert_eq(action_handler._current_frame_index, 0)
	assert_eq(action_handler._current_frame_time, 0.0)

func test_find_closest_frame_loop_disabled():	
	# given
	action_handler.record = InputRecord.new()
	var frame1 = FrameInputRecord.new()
	frame1.frame_time = 0.1
	action_handler.record.inputs = [frame1]
	action_handler.record.final_frame_time = 0.3
	action_handler._current_frame_time = 0.4
	action_handler._current_frame_index = 0
	action_handler.loop = false
	# when
	action_handler._find_closest_frame()
	# then
	assert_null(action_handler.record)

func test_replay_frame():
	# given
	var frame = FrameInputRecord.new()
	frame.relative_aim_position = Vector2(100, 200)
	var input1 = SingleInputRecord.new()
	input1.action = ActionHandlerBase.actions.JUMP
	input1.state = ActionHandlerBase.states.ACTIVE
	var input2 = SingleInputRecord.new()
	input2.action = ActionHandlerBase.actions.LEFT
	input2.state = ActionHandlerBase.states.JUST_ACTIVE
	frame.inputs.append_array([input1, input2])
	# when
	action_handler._replay_frame(frame)
	# then
	assert_eq(action_handler.relative_aim_position, Vector2(100, 200))
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.JUST_ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.RIGHT], ActionHandlerBase.states.INACTIVE)

func test_reset_action_values():
	# given
	action_handler._action_states[ActionHandlerBase.actions.JUMP] = ActionHandlerBase.states.ACTIVE
	action_handler._action_states[ActionHandlerBase.actions.LEFT] = ActionHandlerBase.states.JUST_ACTIVE
	action_handler._action_states[ActionHandlerBase.actions.RIGHT] = ActionHandlerBase.states.JUST_INACTIVE
	# when
	action_handler._reset_action_values()
	# then
	for action in ActionHandlerBase.actions:
		assert_eq(action_handler._action_states[ActionHandlerBase.actions[action]], ActionHandlerBase.states.INACTIVE)

func test_process_starts_recording():
	# given
	var mock_action_handler = partial_double(load("res://Scenes/ActionHandlers/ActionHandlerRecordPlayer/action_handler_record_player.gd")).new()
	stub(mock_action_handler, "_is_record_pressed").to_return(true)
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(false)
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	mock_action_handler._input = input
	mock_action_handler._recording = false
	# when
	mock_action_handler._process(0.16)
	# then
	assert_true(mock_action_handler._recording)
	assert_not_null(mock_action_handler.record)

func test_process_stops_recording():
	# given
	var mock_action_handler = partial_double(load("res://Scenes/ActionHandlers/ActionHandlerRecordPlayer/action_handler_record_player.gd")).new()
	stub(mock_action_handler, "_is_record_pressed").to_return(true)
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(false)
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	stub(input, "is_action_just_pressed").when_passed("record_inputs").to_return(true)
	mock_action_handler._input = input
	mock_action_handler._recording = true
	mock_action_handler._current_frame_time = 1.5
	mock_action_handler.record = InputRecord.new()
	var frame = FrameInputRecord.new()
	frame.relative_aim_position = Vector2(100, 200)
	mock_action_handler.record.inputs.append(frame)
	# when
	mock_action_handler._process(0.16)
	# then
	assert_false(mock_action_handler._recording)
	assert_eq(mock_action_handler.record.final_frame_time, 1.5)

func test_process_records_frame():
	# given
	action_handler._recording = true
	action_handler.record = InputRecord.new()
	action_handler._current_frame_time = 0.0
	# when
	action_handler._process(0.16)
	# then
	assert_gt(action_handler.record.inputs.size(), 0)
	assert_eq(action_handler._current_frame_time, 0.16)

func test_process_replays_frame():
	# given
	action_handler._recording = false
	action_handler.record = InputRecord.new()
	var frame = FrameInputRecord.new()
	frame.relative_aim_position = Vector2(100, 200)
	var input1 = SingleInputRecord.new()
	input1.action = ActionHandlerBase.actions.JUMP
	input1.state = ActionHandlerBase.states.ACTIVE
	var input2 = SingleInputRecord.new()
	input2.action = ActionHandlerBase.actions.LEFT
	input2.state = ActionHandlerBase.states.JUST_ACTIVE
	frame.inputs.append_array([input1, input2])
	frame.frame_time = 0.1
	action_handler.record.inputs.append(frame)
	action_handler.record.final_frame_time = 0.5
	action_handler._current_frame_time = 0.0
	action_handler._current_frame_index = 0
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._current_frame_time, 0.16)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.JUMP], ActionHandlerBase.states.ACTIVE)
	assert_eq(action_handler._action_states[ActionHandlerBase.actions.LEFT], ActionHandlerBase.states.JUST_ACTIVE)

func test_process_do_nothing():
	# given
	action_handler._recording = false
	action_handler.record = null
	action_handler._current_frame_time = 0.0
	# Spy on methods to verify they're not called
	# when
	action_handler._process(0.16)
	# then
	assert_eq(action_handler._current_frame_time, 0.0)
	assert_null(action_handler.record)
	assert_false(action_handler._recording)

var is_record_pressed_params := [
	[true],
	[false]
]
func test_is_record_pressed(params = use_parameters(is_record_pressed_params)):
	# given
	var record_pressed = params[0]
	var input = double(load("res://test/unit/ActionHandler/test_action_handler_record_player_mocks/input.gd")).new()
	stub(input, "is_action_pressed").to_return(false)
	stub(input, "is_action_just_released").to_return(false)
	stub(input, "is_action_just_pressed").to_return(record_pressed)
	action_handler._input = input
	# when
	var res = action_handler._is_record_pressed()
	# then
	assert_eq(res, record_pressed) 
	assert_called(input, "is_action_just_pressed", ["record_inputs"])
