
extends "res://addons/gut/test.gd"

##### VARIABLES #####
var camera_position_manager = null

##### SETUP #####
func before_each():
	camera_position_manager = load("res://Scenes/Camera/camera_position_manager.gd").new()

##### TEARDOWN #####
func after_each():
	camera_position_manager.free()

##### TESTS #####
func test_get_average_position_with_single_player():
	# given
	var player = Node2D.new()
	player.global_position = Vector2(100, 200)
	var players = [player]
	# when
	var result = camera_position_manager.get_average_position(players)
	# then
	assert_eq(result, Vector2(100, 200))
	# cleanup
	player.free()

func test_get_average_position_with_multiple_players():
	# given
	var player1 = Node2D.new()
	player1.global_position = Vector2(100, 200)
	var player2 = Node2D.new()
	player2.global_position = Vector2(300, 400)
	var players = [player1, player2]
	# when
	var result = camera_position_manager.get_average_position(players)
	# then
	assert_eq(result, Vector2(200, 300))
	# cleanup
	player1.free()
	player2.free()

func test_get_average_position_with_empty_array():
	# given
	var players = []
	# when
	var result = camera_position_manager.get_average_position(players)
	# then
	assert_eq(result, Vector2.ZERO)
