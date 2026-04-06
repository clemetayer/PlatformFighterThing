extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var level_bounds


##### SETUP #####
func before_each():
	level_bounds = load("res://Scenes/LevelBounds/level_bounds.gd").new()


##### TEARDOWN #####
func after_each():
	level_bounds.free()

##### TESTS #####
var body_exited_params := [
	[GroupUtils.PLAYER_GROUP_NAME],
	["not_player"],
]


func test_body_exited(params = use_parameters(body_exited_params)):
	# given
	var body = partial_double(load("res://Scenes/Player/player.gd")).new()
	stub(body, "kill").to_do_nothing()
	body.add_to_group(params[0], false)
	# when
	level_bounds._on_body_exited(body)
	# then
	if GroupUtils.PLAYER_GROUP_NAME == params[0]:
		assert_called(body, "kill")
	else:
		assert_not_called(body, "kill")
