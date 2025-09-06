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

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _is_running := false
var _recording : IntegrodotRecording
var _current_frame_time : float = 0.0
var _current_frame_record : IntegrodotFrameRecord

#==== ONREADY ====
@onready var onready_paths := {
	"input_file_name": $"UICanvasLayer/UI/Config/VBoxContainer/VBoxContainer/InputFileName",
	"inputs_folder": $"UICanvasLayer/UI/Config/VBoxContainer/VBoxContainer/InputsFolder",
	"config_manager": $"ConfigManager",
	"select_test_to_record": $"SelectTestToRecord",
	"select_saved_inputs_folder": $"SelectSavedInputsFolder",
	"stop_recording_ui": $"UICanvasLayer/UI/StopRecording",
	"config_ui": $"UICanvasLayer/UI/Config",
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_recording = IntegrodotRecording.new()
	_current_frame_record = IntegrodotFrameRecord.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_config_inputs_folder()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if _is_running:
		_save_frame()
		_current_frame_time += delta

func _notification(what):
	if _is_running and what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_recording()
		get_tree().quit()

##### PROTECTED METHODS #####
func _set_config_inputs_folder() -> void:
	var inputs_folder = onready_paths.config_manager.get_inputs_folder()
	onready_paths.inputs_folder.set_saved_inputs_folder(inputs_folder)

func _add_action_to_recording(action : String, value) -> void:
	var action_record = IntegrodotActionRecord.new()
	action_record.action = action
	action_record.value = value
	_current_frame_record.actions_record.append(action_record)

func _save_frame() -> void:
	_current_frame_record.frame_time = _current_frame_time
	_recording.recording.append(_current_frame_record)
	_current_frame_record = IntegrodotFrameRecord.new()

func _save_recording() -> void:
	ResourceSaver.save(_recording, "%s%s.res" % [_get_inputs_folder(), _get_inputs_filename()])

func _get_inputs_folder() -> String:
	return onready_paths.inputs_folder.get_saved_inputs_folder()

func _get_inputs_filename() -> String:
	return onready_paths.input_file_name.get_inputs_filename()

##### SIGNAL MANAGEMENT #####
func _on_action_executor_record_action(action : String, value) -> void:
	_add_action_to_recording(action, value)

func _on_stop_recording_button_pressed() -> void:
	if _is_running:
		_save_recording()
		get_tree().quit()

func _on_select_test_to_record_file_selected(path: String) -> void:
	_is_running = true
	onready_paths.config_ui.hide()
	onready_paths.stop_recording_ui.show()
	var scene = load(path).instantiate()
	add_child(scene)

func _on_open_scene_to_record_pressed() -> void:
	onready_paths.select_test_to_record.show()

func _on_inputs_folder_select_saved_inputs_folder() -> void:
	onready_paths.select_saved_inputs_folder.show()

func _on_select_saved_inputs_folder_dir_selected(dir: String) -> void:
	onready_paths.inputs_folder.set_saved_inputs_folder(dir)
