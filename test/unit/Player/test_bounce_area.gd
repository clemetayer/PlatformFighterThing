extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var bounce_area

##### SETUP #####
func before_each():
	bounce_area = load("res://Scenes/Player/bounce_area.gd").new()

##### TEARDOWN #####
func after_each():
	bounce_area.free()

##### TESTS #####
# toggle_active fairly hard to test with all those set_deferred things...

func test_on_body_entered():
	# given
	var camera_effects = double(load("res://Scenes/Camera/camera_effects.gd")).new()
	stub(camera_effects, "emit_signal_start_camera_impact").to_do_nothing()
	bounce_area._camera_effects = camera_effects
	var body = Node2D.new()
	# when
	bounce_area._on_body_entered(body)
	# then
	assert_called(camera_effects, "emit_signal_start_camera_impact", [bounce_area.CAMERA_IMPACT_TIME, CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT, CameraEffects.CAMERA_IMPACT_PRIORITY.LOW])
	# cleanup
	body.free()
