extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var scene
var _sender = InputSender.new(Input)

##### SETUP #####
func before_each():
	scene = load("res://test/integration/PlayerMovement/scene_player_movement.tscn").instantiate()
	add_child_autofree(scene)
	await wait_frames(1)
	await wait_seconds(1.0) # waits 1s to make sure the player is initialized and on the floor

##### TEARDOWN #####
func after_each():
	_sender.release_all()
	_sender.clear()

##### TESTS #####
var horizontal_movement_params := [
	["left", -1],
	["right", 1]
]
func test_horizontal_movement(params = use_parameters(horizontal_movement_params)):
	# given
	var action_name = params[0]
	var x_dir_multiplier = params[1]
	var original_position = scene.get_player().global_position
	# when / then
	## checks if moving
	_sender.action_down(action_name).hold_for(.1)
	await(_sender.idle)
	var p_velocity = scene.get_player().velocity
	var p_position = scene.get_player().global_position
	assert_gt(p_velocity.length(), Vector2.ZERO.length())
	if x_dir_multiplier == 1:
		assert_gt(p_position.x, original_position.x)
	else:
		assert_lt(p_position.x, original_position.x)
	## checks if has accelerated
	_sender.action_down(action_name).hold_for(1.0)
	await(_sender.idle)
	var new_velocity = scene.get_player().velocity
	var new_position = scene.get_player().global_position
	assert_gt(new_velocity.length(), p_velocity.length())
	if x_dir_multiplier == 1:
		assert_gt(new_position.x, p_position.x)
	else:
		assert_lt(new_position.x, p_position.x)
	## checks if acceleration has capped
	_sender.action_down(action_name).hold_for(.1)
	await(_sender.idle)
	p_velocity = scene.get_player().velocity
	assert_eq(scene.get_player().velocity.length(), new_velocity.length())
	## tests the collision at the end of the map
	_sender.action_down(action_name).hold_for(3.0)
	await(_sender.idle)
	p_velocity = scene.get_player().velocity
	assert_eq(p_velocity, Vector2.ZERO)

func test_jump():
	# given
	var original_position = scene.get_player().global_position
	# when / then 
	## Checks if the jump works
	_sender.action_down("jump").hold_for(.1)
	await(_sender.idle)
	assert_lt(scene.get_player().velocity.y, 0.0)
	assert_lt(scene.get_player().global_position.y, original_position.y)
	## Checks if the player falls down after some time
	await wait_seconds(0.5)
	assert_gt(scene.get_player().velocity.y, 0.0)
	assert_lt(scene.get_player().global_position.y, original_position.y)
	## Checks that there is no double jump
	_sender.action_down("jump").hold_for(.1)
	await(_sender.idle)
	assert_gt(scene.get_player().velocity.y, 0.0)
	assert_lt(scene.get_player().global_position.y, original_position.y)


var jump_with_horizontal_movement_params := [
	["left", -1],
	["right", 1]
]
func test_jump_with_horizontal_movement(params = use_parameters(jump_with_horizontal_movement_params)):
	# given
	var action_name = params[0]
	var x_dir_multiplier = params[1]
	var original_position = scene.get_player().global_position
	# when
	_sender.action_down("jump").action_down(action_name).hold_for(.3)
	await(_sender.idle)
	# then
	var p_velocity = scene.get_player().velocity
	var p_position = scene.get_player().global_position
	assert_lt(p_velocity.y, 0.0)
	assert_lt(p_position.y, original_position.y)
	assert_gt(p_velocity.length(), Vector2.ZERO.length())
	if x_dir_multiplier == 1:
		assert_gt(p_position.x, original_position.x)
	else:
		assert_lt(p_position.x, original_position.x)
