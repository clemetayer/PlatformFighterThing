extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
const BODY_SIZE_SIDE_HALF := 42.24 

#---- VARIABLES -----
var scene

##### SETUP #####
func before_each():
	scene = load("res://Scenes/Player/predict_bounces_ray_cast.gd").new()

##### TEARDOWN #####
func after_each():
	scene.free()

##### TESTS #####

# can't really test predict_bounces...

var get_additional_body_size_point_params := [
	[Vector2.RIGHT, Vector2.RIGHT * 42.24],
	[Vector2.UP, Vector2.UP * 42.24],
	[Vector2.DOWN, Vector2.DOWN * 42.24],
	[Vector2.LEFT, Vector2.LEFT * 42.24],
	[Vector2(-0.2,0.5), Vector2(-0.4,1.0) * 42.24]
]
func test_get_additional_body_size_point(params = use_parameters(get_additional_body_size_point_params)):
	# given
	var direction = params[0]
	var expected = params[1]
	# when
	var res = scene._get_additional_body_size_point(direction)
	# then
	assert_eq(res, expected)

