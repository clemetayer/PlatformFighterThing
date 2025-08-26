extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var runtime_config

##### SETUP #####
func before_each():
	runtime_config = load("res://Utils/Config/runtime_config.gd").new()

##### TEARDOWN #####
func after_each():
	runtime_config.free()

##### TESTS #####
var process_params := [
	[true, DisplayServer.WINDOW_MODE_FULLSCREEN],
	[true, DisplayServer.WINDOW_MODE_WINDOWED],
	[false, DisplayServer.WINDOW_MODE_FULLSCREEN]
]
func test_process(params = use_parameters(process_params)):
	# given
	var toggle_fullscreen_pressed = params[0]
	var window_mode = params[1]
	var display_server = double(load("res://test/unit/Utils/test_runtime_config_mocks/display_server.gd")).new()
	stub(display_server, "window_get_mode").to_return(window_mode)
	stub(display_server, "window_set_mode").to_do_nothing()
	runtime_config._display_server = display_server
	var input = double(load("res://test/unit/Utils/test_runtime_config_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(toggle_fullscreen_pressed)
	runtime_config._input = input
	# when
	runtime_config._process(1.0/60.0)
	# then
	assert_called(input, "is_action_just_pressed", ["temp_toggle_fullscreen"])
	if toggle_fullscreen_pressed:
		if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			assert_called(display_server, "window_set_mode", [DisplayServer.WINDOW_MODE_WINDOWED])
		else:
			assert_called(display_server, "window_set_mode", [DisplayServer.WINDOW_MODE_FULLSCREEN])
	else:
		assert_not_called(display_server, "window_set_mode")

var toggle_bgm_params := [
	[true],
	[false]
]
func test_toggle_bgm(params = use_parameters(toggle_bgm_params)):
	# given
	var active = params[0]
	var audio_server = double(load("res://test/unit/Utils/test_runtime_config_mocks/audio_server.gd")).new()
	stub(audio_server, "get_bus_index").to_return(3)
	stub(audio_server, "set_bus_mute").to_do_nothing()
	runtime_config._audio_server = audio_server
	# when 
	runtime_config.toggle_bgm(active)
	# then
	assert_called(audio_server, "set_bus_mute", [3, not active])

var set_visual_intensity_params := [
	[RuntimeConfig.VISUAL_INTENSITY.HIGH],
	[RuntimeConfig.VISUAL_INTENSITY.LOW]
]
func test_set_visual_intensity(params = use_parameters(set_visual_intensity_params)):
	# given
	var intensity = params[0]
	# when
	runtime_config.set_visual_intensity(intensity)
	# then
	assert_eq(runtime_config.visual_intensity, intensity)

var set_camera_effects_intensity_params := [
	[RuntimeConfig.CAMERA_EFFECTS_INTENSITY.HIGH],
	[RuntimeConfig.CAMERA_EFFECTS_INTENSITY.LOW]
]
func test_set_camera_effects_intensity(params = use_parameters(set_camera_effects_intensity_params)):
	# given
	var intensity = params[0]
	var expected_preset = load(runtime_config.CAMERA_EFFECTS_INTENSITY_PRESETS_PATH[intensity])
	# when
	runtime_config.set_camera_effects_intensity(intensity)
	# then
	assert_eq(runtime_config.camera_effects_intensity_preset, expected_preset)
