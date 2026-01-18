extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var popup

##### SETUP #####
func before_each():
	popup = load("res://Scenes/UI/PlayerCustomizationMenu/save_preset_popup.gd").new()

##### TEARDOWN #####
func after_each():
	popup.free()

##### TESTS #####
func test_set_preset_to_save():
	# given
	var config = PlayerConfig.new()
	# when
	popup.set_preset_to_save(config)
	# then
	assert_eq(popup._preset_to_save, config)

func test_save_preset():
	# given
	var preset_name = LineEdit.new()
	preset_name.text = "gdunittest"
	popup.onready_paths.preset_name = preset_name
	var config = PlayerConfig.new()
	config.PLAYER_NAME = "gdunittest"
	popup._preset_to_save = config
	# when
	popup._save_preset()
	# then
	var preset_path = StaticUtils.USER_CHARACTER_PRESETS_PATH + "gdunittest" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
	assert_true(ResourceLoader.exists(preset_path))
	var saved_resource = load(preset_path)
	assert_eq(saved_resource.PLAYER_NAME, "gdunittest")
	# cleanup
	preset_name.free()
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(preset_path)

func test_on_confirmed():
	# given
	var preset_name = LineEdit.new()
	preset_name.text = "gdunittest"
	popup.onready_paths.preset_name = preset_name
	var config = PlayerConfig.new()
	config.PLAYER_NAME = "gdunittest"
	popup._preset_to_save = config
	popup.show()
	# when
	popup._on_confirmed()
	# then
	var preset_path = StaticUtils.USER_CHARACTER_PRESETS_PATH + "gdunittest" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
	assert_true(ResourceLoader.exists(preset_path))
	var saved_resource = load(preset_path)
	assert_eq(saved_resource.PLAYER_NAME, "gdunittest")
	assert_false(popup.visible)
	# cleanup
	preset_name.free()
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(preset_path)

func test_on_override_preset_popup_confirmed():
	# given
	var preset_name = LineEdit.new()
	preset_name.text = "gdunittest"
	popup.onready_paths.preset_name = preset_name
	var config = PlayerConfig.new()
	config.PLAYER_NAME = "gdunittest"
	popup._preset_to_save = config
	# when
	popup._on_override_preset_popup_confirmed()
	# then
	var preset_path = StaticUtils.USER_CHARACTER_PRESETS_PATH + "gdunittest" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
	assert_true(ResourceLoader.exists(preset_path))
	var saved_resource = load(preset_path)
	assert_eq(saved_resource.PLAYER_NAME, "gdunittest")
	# cleanup
	preset_name.free()
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(preset_path)