extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var player_interaction_manager
var toggle_freeze_called := false
var toggle_freeze_args := []
var override_velocity_called := false
var override_velocity_args := []
var kill_called := false

##### SETUP #####
func before_each():
	player_interaction_manager = load("res://Scenes/DestructibleWalls/player_interaction_manager.gd").new()
	add_child_autofree(player_interaction_manager)
	toggle_freeze_called = false
	toggle_freeze_args = []
	override_velocity_called = false
	override_velocity_args = []
	kill_called = false

##### TESTS #####
func test_player_hit():
	# given
	var timers = Node.new()
	player_interaction_manager.onready_paths.freeze_player_timers = timers
	player_interaction_manager.add_child(timers)
	var player = load("res://test/unit/DestructibleWall/test_player_interaction_manager_mocks/player_mock.gd").new()
	player.connect("toggle_freeze_called", _on_player_toggle_freeze_called)
	add_child(player)
	wait_for_signal(player.tree_entered, 1)
	# when
	player_interaction_manager.handle_player_hit(player, Vector2.RIGHT, 2.0)
	# then
	assert_true(toggle_freeze_called)
	assert_eq(toggle_freeze_args, [true])
	assert_eq(timers.get_child_count(), 1)
	var timer = timers.get_children(0)[0]
	assert_false(timer.paused)
	# cleanup
	timers.free()
	player.free()

func test_kill_player():
	# given
	var player = load("res://test/unit/DestructibleWall/test_player_interaction_manager_mocks/player_mock.gd").new()
	player.connect("kill_called", _on_player_kill_called)
	add_child(player)
	wait_for_signal(player.tree_entered, 1)
	# when
	player_interaction_manager.kill_player(player)
	# then
	assert_true(kill_called)

func test_start_freeze_player_timeout_time_for_player():
	# given
	var timers = Node2D.new()
	player_interaction_manager.onready_paths.freeze_player_timers = timers
	player_interaction_manager.add_child(timers)
	var player = Node2D.new()
	# when
	player_interaction_manager._start_freeze_timeout_timer_for_player(player, Vector2.RIGHT, 2.0, 0.1)
	# then
	assert_eq(timers.get_child_count(), 1)
	var timer = timers.get_children(0)[0]
	assert_false(timer.paused)
	assert_eq(timer.wait_time, 0.1)
	assert_true(timer.one_shot)
	assert_true(timer.has_connections("timeout"))
	# cleanup
	timers.free()
	player.free()

func test_on_freeze_player_timer_timeout_not_destroyed():
	# given 
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(true)
	player_interaction_manager._runtime_utils = runtime_utils
	var player = load("res://test/unit/DestructibleWall/test_player_interaction_manager_mocks/player_mock.gd").new()
	player.connect("toggle_freeze_called", _on_player_toggle_freeze_called)
	player.connect("override_velocity_called", _on_player_override_velocity_called)
	add_child(player)
	wait_for_signal(player.tree_entered, 1)
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	var health_manager = double(load("res://Scenes/DestructibleWalls/health_manager.gd")).new()
	stub(health_manager, "is_destroyed").to_return(false)
	player_interaction_manager.onready_paths.health_manager = health_manager
	var audio_manager = double(load("res://Scenes/DestructibleWalls/audio_manager.gd")).new()
	stub(audio_manager, "stop_trebble").to_do_nothing()
	player_interaction_manager.onready_paths.audio_manager = audio_manager
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_called(audio_manager, "stop_trebble")
	assert_true(toggle_freeze_called)
	assert_eq(toggle_freeze_args, [false])
	assert_true(override_velocity_called)
	assert_eq(override_velocity_args, [Vector2.RIGHT * 2.0])
	# cleanup
	timer.free()
	player.free()

func test_on_freeze_player_timer_timeout_destroyed():
	# given
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(true)
	player_interaction_manager._runtime_utils = runtime_utils
	var player = load("res://test/unit/DestructibleWall/test_player_interaction_manager_mocks/player_mock.gd").new()
	player.connect("toggle_freeze_called", _on_player_toggle_freeze_called)
	player.connect("override_velocity_called", _on_player_override_velocity_called)
	add_child(player)
	wait_for_signal(player.tree_entered, 1)
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	var health_manager = double(load("res://Scenes/DestructibleWalls/health_manager.gd")).new()
	stub(health_manager, "is_destroyed").to_return(true)
	player_interaction_manager.onready_paths.health_manager = health_manager
	var audio_manager = double(load("res://Scenes/DestructibleWalls/audio_manager.gd")).new()
	stub(audio_manager, "stop_trebble").to_do_nothing()
	player_interaction_manager.onready_paths.audio_manager = audio_manager
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_called(audio_manager, "stop_trebble")
	assert_true(toggle_freeze_called)
	assert_eq(toggle_freeze_args, [false])
	assert_true(override_velocity_called)
	assert_eq(override_velocity_args, [-Vector2.RIGHT * player_interaction_manager.WALL_BREAK_KNOCKBACK_STRENGTH])
	# cleanup
	timer.free()
	player.free()

func test_on_freeze_player_timer_timeout_not_authority():
	# given
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(false)
	player_interaction_manager._runtime_utils = runtime_utils
	var player = load("res://test/unit/DestructibleWall/test_player_interaction_manager_mocks/player_mock.gd").new()
	player.connect("toggle_freeze_called", _on_player_toggle_freeze_called)
	player.connect("override_velocity_called", _on_player_override_velocity_called)
	add_child(player)
	wait_for_signal(player.tree_entered, 1)
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	var health_manager = double(load("res://Scenes/DestructibleWalls/health_manager.gd")).new()
	stub(health_manager, "is_destroyed").to_return(true)
	player_interaction_manager.onready_paths.health_manager = health_manager
	var audio_manager = double(load("res://Scenes/DestructibleWalls/audio_manager.gd")).new()
	stub(audio_manager, "stop_trebble").to_do_nothing()
	player_interaction_manager.onready_paths.audio_manager = audio_manager
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_not_called(audio_manager, "stop_trebble")
	assert_false(toggle_freeze_called)
	assert_false(override_velocity_called)
	assert_not_called(health_manager, "is_destroyed")
	# cleanup
	timer.free()
	player.free()

func test_on_freeze_player_timer_timeout_player_invalid():
	# given
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(true)
	player_interaction_manager._runtime_utils = runtime_utils
	var player = null
	var timer = Timer.new()
	add_child(timer)
	wait_for_signal(timer.tree_entered, 1)
	var health_manager = double(load("res://Scenes/DestructibleWalls/health_manager.gd")).new()
	stub(health_manager, "is_destroyed").to_return(true)
	player_interaction_manager.onready_paths.health_manager = health_manager
	var audio_manager = double(load("res://Scenes/DestructibleWalls/audio_manager.gd")).new()
	stub(audio_manager, "stop_trebble").to_do_nothing()
	player_interaction_manager.onready_paths.audio_manager = audio_manager
	# when
	player_interaction_manager._on_freeze_player_timer_timeout(timer, player, Vector2.RIGHT, 2.0)
	# then
	assert_not_called(audio_manager, "stop_trebble")
	assert_false(toggle_freeze_called)
	assert_false(override_velocity_called)
	assert_not_called(health_manager, "is_destroyed")
	# cleanup
	timer.free()

##### UTILS #####
func _on_player_toggle_freeze_called(value: bool) -> void:
	toggle_freeze_called = true
	toggle_freeze_args = [value]

func _on_player_override_velocity_called(bounce_direction: Vector2) -> void:
	override_velocity_called = true
	override_velocity_args = [bounce_direction]

func _on_player_kill_called() -> void:
	kill_called = true
