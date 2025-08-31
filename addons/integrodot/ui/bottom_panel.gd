@tool
extends Control
# UI for the Integrodot addon

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"integration_tests_folder": $"HBoxContainer/VBoxContainer/IntegrationTestsFolder",
	"results_folder": $"HBoxContainer/VBoxContainer/ResultsFolder",
	"inputs_filename": $"HBoxContainer/VBoxContainer2/InputsFilename",
	"saved_inputs_folder": $"HBoxContainer/VBoxContainer2/SavedInputsFolder",
	"select_specific_test_to_run": $"SelectSpecificTestToRun",
	"select_test_result_folder": $"SelectTestResultsFolder",
	"select_integration_test_folder": $"SelectIntegrationTestFolder",
	"select_test_to_record": $"SelectTestToRecord",
	"select_saved_inputs_folder": $"SelectSavedInputsFolder"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
func _on_select_specific_test_to_run_file_selected(path: String) -> void:
	pass

func _on_select_integration_test_folder_dir_selected(dir: String) -> void:
	onready_paths.integration_tests_folder.set_integration_test_folder(dir)

func _on_select_test_results_folder_dir_selected(dir: String) -> void:
	onready_paths.results_folder.set_results_folder(dir)

func _on_select_test_to_record_file_selected(path: String) -> void:
	pass # Replace with function body.

func _on_select_saved_inputs_folder_dir_selected(dir: String) -> void:
	onready_paths.saved_inputs_folder.set_saved_inputs_folder(dir)

func _on_saved_inputs_folder_select_saved_inputs_folder() -> void:
	onready_paths.select_saved_inputs_folder.show()

func _on_record_inputs_record_inputs() -> void:
	onready_paths.select_test_to_record.show()

func _on_results_folder_select_results_folder() -> void:
	onready_paths.select_test_result_folder.show()

func _on_integration_tests_folder_select_integration_tests_folder() -> void:
	onready_paths.select_integration_test_folder.show()

func _on_run_tests_run_all() -> void:
	pass # Replace with function body.

func _on_run_tests_run_specific_test() -> void:
	onready_paths.select_specific_test_to_run.show()
