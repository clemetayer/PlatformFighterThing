@tool
extends Control
# UI for the Integrodot addon

##### VARIABLES #####
#---- CONSTANTS -----
const TEST_RECORDER_SCENE_PATH := "res://addons/integrodot/roots/TestRecorder/test_recorder.tscn"
const TEST_RUNNER_SCENE_PATH := "res://addons/integrodot/roots/TestRunner/test_runner.tscn"

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"integration_tests_folder": $"HBoxContainer/VBoxContainer/IntegrationTestsFolder",
	"saved_inputs_folder": $"HBoxContainer/VBoxContainer2/SavedInputsFolder",
	"select_integration_test_folder": $"SelectIntegrationTestFolder",
	"select_saved_inputs_folder": $"SelectSavedInputsFolder",
	"config_manager": $"ConfigManager"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_load_config()

##### PROTECTED METHODS #####
func _load_config() -> void:
	var config_test_folder = onready_paths.config_manager.get_test_folder()
	var config_inputs_folder = onready_paths.config_manager.get_inputs_folder()
	onready_paths.integration_tests_folder.set_integration_test_folder(config_test_folder)
	onready_paths.saved_inputs_folder.set_saved_inputs_folder(config_inputs_folder)

##### SIGNAL MANAGEMENT #####
func _on_select_integration_test_folder_dir_selected(dir: String) -> void:
	onready_paths.integration_tests_folder.set_integration_test_folder(dir)
	onready_paths.config_manager.set_test_folder(dir)

func _on_select_saved_inputs_folder_dir_selected(dir: String) -> void:
	onready_paths.saved_inputs_folder.set_saved_inputs_folder(dir)
	onready_paths.config_manager.set_inputs_folder(dir)

func _on_saved_inputs_folder_select_saved_inputs_folder() -> void:
	onready_paths.select_saved_inputs_folder.show()

func _on_integration_tests_folder_select_integration_tests_folder() -> void:
	onready_paths.select_integration_test_folder.show()

func _on_open_runner_pressed() -> void:
	EditorInterface.play_custom_scene(TEST_RUNNER_SCENE_PATH)

func _on_open_recorder_pressed() -> void:
	EditorInterface.play_custom_scene(TEST_RECORDER_SCENE_PATH)
