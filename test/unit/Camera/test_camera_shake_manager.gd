extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var camera_shake_manager: Node
var mock_shaker: Node

##### SETUP #####
func before_each():
	# Create a basic scene structure
	mock_shaker = double(load("res://addons/shaker/src/Vector2/shaker_component2D.gd")).new()
	camera_shake_manager = load("res://Scenes/Camera/camera_shake_manager.gd").new()
	camera_shake_manager.shaker = mock_shaker

##### TEARDOWN #####
func after_each():
	camera_shake_manager.free()

##### TESTS #####
var camera_shakes_parameters = [
	[CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT,RuntimeConfig.camera_effects_intensity_preset.SHAKE_LOW],
	[CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM,RuntimeConfig.camera_effects_intensity_preset.SHAKE_MID],
	[CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH,RuntimeConfig.camera_effects_intensity_preset.SHAKE_HIGH]
]
func test_start_camera_shake(params=use_parameters(camera_shakes_parameters)):
	# given
	var duration = 1.0
	var intensity = params[0]
	mock_shaker.is_playing = true
	stub(mock_shaker,"force_stop_shake").to_do_nothing()
	stub(mock_shaker, "set_duration").to_do_nothing()
	stub(mock_shaker, "set_shaker_preset").to_do_nothing()
	stub(mock_shaker, "play_shake").to_do_nothing()
	# when
	camera_shake_manager.start_camera_shake(duration, intensity)
	# then
	assert_called(mock_shaker, "force_stop_shake")
	assert_called(mock_shaker, "set_duration", [duration])
	assert_called(mock_shaker, "set_shaker_preset", [params[1]])
	assert_called(mock_shaker, "play_shake")

var camera_tilts_parameters = [
	[CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT,RuntimeConfig.camera_effects_intensity_preset.LOW_TILT_ROTATION_ANGLE, RuntimeConfig.camera_effects_intensity_preset.LOW_TILT_DURATION_DIVIDER],
	[CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM,RuntimeConfig.camera_effects_intensity_preset.MID_TILT_ROTATION_ANGLE, RuntimeConfig.camera_effects_intensity_preset.MID_TILT_DURATION_DIVIDER],
	[CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH,RuntimeConfig.camera_effects_intensity_preset.HIGH_TILT_ROTATION_ANGLE, RuntimeConfig.camera_effects_intensity_preset.HIGH_TILT_DURATION_DIVIDER]
]
func test_start_camera_tilt(params=use_parameters(camera_tilts_parameters)):
	# given
	var duration = 1.0
	var intensity = params[0]
	var mock_shake_manager = partial_double(load("res://Scenes/Camera/camera_shake_manager.gd")).new()
	stub(mock_shake_manager, "_tilt_camera").to_do_nothing()
	# when
	mock_shake_manager.start_camera_tilt(duration, intensity)

	# then
	assert_called(mock_shake_manager, "_tilt_camera")
	var call_params = get_call_parameters(mock_shake_manager, "_tilt_camera")
	# Check the absolute angle value is correct
	assert_almost_eq(abs(call_params[0]), params[1], 0.001)
	assert_eq(call_params[1], duration)
	assert_eq(call_params[2], params[2])
