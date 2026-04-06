extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var player_interaction_manager


##### SETUP #####
func before_each():
	player_interaction_manager = load("res://Scenes/DestructibleWalls/player_interactions_manager.gd").new()
	var freeze_player_timers = Node.new()
	add_child_autofree(freeze_player_timers)
	player_interaction_manager.onready_paths.freeze_player_timers = freeze_player_timers
	var audio_manager = double(load("res://Scenes/DestructibleWalls/audio_manager.gd")).new()
	player_interaction_manager.onready_paths.audio_manager = audio_manager
	var health_manager = double(load("res://Scenes/DestructibleWalls/health_manager.gd")).new()
	player_interaction_manager.onready_paths.health_manager = health_manager


##### TEARDOWN #####
func after_each():
	player_interaction_manager.free()


##### TESTS #####
func test_player_hit():
	# given
	var player = double(load("res://Scenes/Player/player.gd")).new()
	stub(player, "toggle_freeze").to_do_nothing()
	# when
	player_interaction_manager.handle_player_hit(player, Vector2.RIGHT, 2.0)
	# then
	assert_called(player, "toggle_freeze", [true])
	var timers = player_interaction_manager.onready_paths.freeze_player_timers
	assert_eq(timers.get_child_count(), 1)
	var timer = timers.get_children(0)[0]
	assert_false(timer.paused)


func test_kill_player():
	# given
	var player = double(load("res://Scenes/Player/player.gd")).new()
	stub(player, "kill").to_do_nothing()
	player_interaction_manager.kill_player(player)
	# when
	# then
	assert_called(player, "kill")


func test_start_freeze_player_timeout_time_for_player():
	# given
	var player = Node2D.new()
	# when
	player_interaction_manager._start_freeze_timeout_timer_for_player(player, Vector2.RIGHT, 2.0, 0.1)
	# then
	var timers = player_interaction_manager.onready_paths.freeze_player_timers
	assert_eq(timers.get_child_count(), 1)
	var timer = timers.get_children(0)[0]
	assert_false(timer.paused)
	assert_eq(timer.wait_time, 0.1)
	assert_true(timer.one_shot)
	assert_true(timer.has_connections("timeout"))
	# cleanup
	player.free()


func test_on_freeze_player_timer_timeout_not_destroyed():
	# given
	var audio_manager = player_interaction_manager.onready_paths.audio_manager
	stub(audio_manager, "stop_trebble").to_do_nothing()
	var health_manager = player_interaction_manager.onready_paths.health_manager
	stub(health_manager, "is_destroyed").to_return(false)
	var player = double(load("res://Scenes/Player/player.gd")).new()
	stub(player, "toggle_freeze").to_do_nothing()
	stub(player, "override_velocity").to_do_nothing()
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_called(audio_manager, "stop_trebble")
	assert_called(player, "toggle_freeze", [false])
	assert_called(player, "override_velocity", [Vector2.RIGHT * 2.0])
	# cleanup
	timer.free()


func test_on_freeze_player_timer_timeout_destroyed():
	# given
	var audio_manager = player_interaction_manager.onready_paths.audio_manager
	stub(audio_manager, "stop_trebble").to_do_nothing()
	var health_manager = player_interaction_manager.onready_paths.health_manager
	stub(health_manager, "is_destroyed").to_return(true)
	var player = double(load("res://Scenes/Player/player.gd")).new()
	stub(player, "toggle_freeze").to_do_nothing()
	stub(player, "override_velocity").to_do_nothing()
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_called(audio_manager, "stop_trebble")
	assert_called(player, "toggle_freeze", [false])
	assert_called(player, "override_velocity", [-Vector2.RIGHT * player_interaction_manager.WALL_BREAK_KNOCKBACK_STRENGTH])
	# cleanup
	timer.free()


func test_on_freeze_player_timer_timeout_player_invalid():
	# given
	var audio_manager = player_interaction_manager.onready_paths.audio_manager
	stub(audio_manager, "stop_trebble").to_do_nothing()
	var health_manager = player_interaction_manager.onready_paths.health_manager
	stub(health_manager, "is_destroyed").to_return(true)
	var player = null
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_not_called(audio_manager, "stop_trebble")
	assert_not_called(health_manager, "is_destroyed")
	# cleanup
	timer.free()
