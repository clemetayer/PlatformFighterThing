extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var hitstun_manager

##### SETUP #####
func before_each():
	hitstun_manager = load("res://Scenes/Player/hitstun_manager.gd").new()

##### TEARDOWN #####
func after_each():
	hitstun_manager.free()

##### TESTS #####
var stop_hitstun_params := [
	[true],
	[false]
]
func test_stop_hitstun(params = use_parameters(stop_hitstun_params)):
	# given
	var mock_hitstun_manager = partial_double(load("res://Scenes/Player/hitstun_manager.gd")).new()
	stub(mock_hitstun_manager, "_on_hitstun_timeout").to_do_nothing()
	var hitstun_timer = double(Timer).new()
	stub(hitstun_timer, "stop")
	mock_hitstun_manager.hitstunned = params[0]
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.hitstun_timer = hitstun_timer
	mock_hitstun_manager.onready_paths_node = onready_paths_node
	# when
	mock_hitstun_manager.stop_hitstun()
	# then
	if params[0]:
		assert_called(hitstun_timer, "stop")
		assert_called(mock_hitstun_manager, "_on_hitstun_timeout")
	else:
		assert_not_called(hitstun_timer, "stop")
		assert_not_called(mock_hitstun_manager, "_on_hitstun_timeout")
	# cleanup
	onready_paths_node.free()

func test_start_hitstun():
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var hitstun_timer = double(Timer).new()
	stub(hitstun_timer, "start").to_do_nothing()
	onready_paths_node.hitstun_timer = hitstun_timer
	var animation_player = double(AnimationPlayer).new()
	stub(animation_player,"play").to_do_nothing()
	onready_paths_node.animation_player = animation_player
	var bounce_area = double(load("res://Scenes/Player/bounce_area.gd")).new()
	stub(bounce_area, "toggle_active").to_do_nothing()
	onready_paths_node.bounce_area = bounce_area
	hitstun_manager.onready_paths_node = onready_paths_node
	# when
	hitstun_manager.start_hitstun(123)
	# then
	assert_called(hitstun_timer, "start")
	assert_called(animation_player, "play", ["hitstun", null, null, null])
	assert_called(bounce_area, "toggle_active", [true])
	assert_true(hitstun_manager.hitstunned)
	# cleanup
	onready_paths_node.free()

func test_on_hitstun_timeout():
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var animation_player = double(AnimationPlayer).new()
	stub(animation_player,"stop").to_do_nothing()
	stub(animation_player,"play").to_do_nothing()
	onready_paths_node.animation_player = animation_player
	var bounce_area = double(load("res://Scenes/Player/bounce_area.gd")).new()
	stub(bounce_area, "toggle_active").to_do_nothing()
	onready_paths_node.bounce_area = bounce_area
	hitstun_manager.onready_paths_node = onready_paths_node
	# when
	hitstun_manager._on_hitstun_timeout()
	# then
	assert_called(animation_player, "stop")
	assert_called(animation_player, "play", ["RESET", null, null, null])
	assert_called(bounce_area, "toggle_active", [false])
	assert_false(hitstun_manager.hitstunned)
	# cleanup
	onready_paths_node.free()

##### UTILS #####
func _something_useful():
	pass
