extends Node
class_name IntegrodotTestRecorder
# Records actions to later replay for the integration test

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
@export var INPUT_SAVE_PATH := "res://"
@export var INPUT_SAVE_NAME := "you_should_really_setup_a_custom_input_filename"

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var recording : IntegrodotRecording
var current_frame_time : float = 0.0
var current_frame_record : IntegrodotFrameRecord

#==== ONREADY ====
# @onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	recording = IntegrodotRecording.new()
	current_frame_record = IntegrodotFrameRecord.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	_save_frame()
	current_frame_time += delta

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_recording()
		get_tree().quit()

##### PROTECTED METHODS #####
func _add_action_to_recording(action : String, value) -> void:
	var action_record = IntegrodotActionRecord.new()
	action_record.action = action
	action_record.value = value
	current_frame_record.actions_record.append(action_record)

func _save_frame() -> void:
	current_frame_record.frame_time = current_frame_time
	recording.recording.append(current_frame_record)
	current_frame_record = IntegrodotFrameRecord.new()

func _save_recording() -> void:
	ResourceSaver.save(recording, "%s%s.tres" % [INPUT_SAVE_PATH, INPUT_SAVE_NAME])

##### SIGNAL MANAGEMENT #####
func _on_action_executor_record_action(action : String, value) -> void:
	_add_action_to_recording(action, value)

func _on_stop_recording_button_pressed() -> void:
	_save_recording()
	get_tree().quit()
