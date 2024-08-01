extends ActionHandlerBase
class_name ActionHandlerRecordPlayer
# records/replays a recording of the actions pressed by a player

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
@export var loop := true

#---- STANDARD -----
#==== PUBLIC ====
var record : InputRecord = null

#==== PRIVATE ====
var _current_frame_time := 0
var _current_frame_index := 0
var _recording := false

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if Input.is_action_just_pressed("record_inputs"):
		if _recording:
			_stop_recording()
		else:
			_start_record()
	if _recording:
		_listen_to_inputs()
		_record_frame()
		_current_frame_time += delta
	elif record != null:
		_replay_frame(_find_closest_frame())
		_current_frame_time += delta

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _start_record() -> void:
	record = InputRecord.new()
	_recording = true
	_current_frame_time = 0

func _stop_recording() -> void:
	_recording = false
	record.final_frame_time = _current_frame_time
	_current_frame_time = 0

func _record_frame() -> void:
	var frame = FrameInputRecord.new()
	frame.frame_time = _current_frame_time
	_add_action_input_if_needed("jump", jump, frame)
	_add_action_input_if_needed("up", up, frame)
	_add_action_input_if_needed("down", down, frame)
	_add_action_input_if_needed("left", left, frame)
	_add_action_input_if_needed("right", right, frame)
	_add_action_input_if_needed("fire", fire, frame)
	record.inputs.append(frame)

func _add_action_input_if_needed(action : String, state: ActionHandlerBase.states, frame : FrameInputRecord) -> void:
	if state != ActionHandlerBase.states.INACTIVE:
		var single_input_record := SingleInputRecord.new()
		single_input_record.action = action
		single_input_record.state = state
		frame.inputs.append(single_input_record)
	
func _listen_to_inputs() -> void:
	jump = _generic_get_action_state("jump")
	left = _generic_get_action_state("left")
	right = _generic_get_action_state("right")
	up = _generic_get_action_state("up")
	down = _generic_get_action_state("down")
	fire = _generic_get_action_state("fire")

func _generic_get_action_state(input_action : String) -> states:
	if Input.is_action_just_pressed(input_action):
		return states.JUST_ACTIVE
	elif Input.is_action_pressed(input_action):
		return states.ACTIVE
	elif Input.is_action_just_released(input_action):
		return states.JUST_INACTIVE
	return states.INACTIVE

func _find_closest_frame() -> FrameInputRecord:
	if _current_frame_time > record.final_frame_time:
		_current_frame_index = 0
		_current_frame_time = 0
	else:
		# find the next closest frame
		while _current_frame_time > record.inputs[_current_frame_index].frame_time and _current_frame_index < record.inputs.size(): # oooh, dangerous ! 
			_current_frame_index += 1  
	return record.inputs[_current_frame_index]

func _replay_frame(frame : FrameInputRecord) -> void:
	_reset_action_values()
	for input in frame.inputs:
		match input.action:
			"jump":
				jump = input.state
			"up":
				up = input.state
			"down":
				down = input.state
			"left":
				left = input.state
			"right":
				right = input.state
			"fire":
				fire = input.state

func _reset_action_values() -> void:
	jump = ActionHandlerBase.states.INACTIVE
	left = ActionHandlerBase.states.INACTIVE
	right = ActionHandlerBase.states.INACTIVE
	up = ActionHandlerBase.states.INACTIVE
	down = ActionHandlerBase.states.INACTIVE
	fire = ActionHandlerBase.states.INACTIVE

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

