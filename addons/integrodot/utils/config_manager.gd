@tool
extends Node
# Manages the config for the Integrodot plugin

##### VARIABLES #####
#---- CONSTANTS -----
#==== UTILS ====
const SAVE_PATH := "res://addons/integrodot/"
const CONFIG_FILE_NAME := "integrodot.conf"

#==== CONFIGS ====
var SECTION_RUNNER := "runner"
var CONFIG_TEST_FOLDER_PATH := "test_folder_path"
var SECTION_RECORDER := "recorder"
var CONFIG_INPUTS_FOLDER := "inputs_save_folder"

#---- STANDARD -----
#==== PUBLIC ====
var _test_folder := "res://"
var _saved_inputs_folder := "res://"

#==== PRIVATE ====
var _config : ConfigFile

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_config = ConfigFile.new()
	var err = _config.load(SAVE_PATH + CONFIG_FILE_NAME)
	if err == OK:
		_load_config()
	else:
		_set_default_config()

##### PUBLIC METHODS #####
func get_test_folder() -> String:
	return _test_folder

func set_test_folder(folder : String) -> void:
	_test_folder = folder
	_config.set_value(SECTION_RUNNER, CONFIG_TEST_FOLDER_PATH, _test_folder)
	_config.save(SAVE_PATH + CONFIG_FILE_NAME)

func get_inputs_folder() -> String:
	return _test_folder

func set_inputs_folder(folder : String) -> void:
	_saved_inputs_folder = folder
	_config.set_value(SECTION_RECORDER, CONFIG_INPUTS_FOLDER, _saved_inputs_folder)
	_config.save(SAVE_PATH + CONFIG_FILE_NAME)

##### PROTECTED METHODS #####
func _set_default_config() -> void:
	_config.set_value(SECTION_RUNNER, CONFIG_TEST_FOLDER_PATH, _test_folder)
	_config.set_value(SECTION_RECORDER, CONFIG_INPUTS_FOLDER, _saved_inputs_folder)
	_config.save(SAVE_PATH + CONFIG_FILE_NAME)

func _load_config() -> void:
	_test_folder = _config.get_value(SECTION_RUNNER, CONFIG_TEST_FOLDER_PATH)
	_saved_inputs_folder = _config.get_value(SECTION_RECORDER, CONFIG_INPUTS_FOLDER)
