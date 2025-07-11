extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var respawn_manager
var wall_respawned_called := false

##### SETUP #####
func before_each():
	respawn_manager = load("res://Scenes/DestructibleWalls/respawn_manager.gd").new()
	wall_respawned_called = false

##### TEARDOWN #####
func after_each():
	respawn_manager.free()

##### TESTS #####
var test_enable_respawn_detection_params := [
	[true],
	[false]
]
func test_enable_respawn_detection(params = use_parameters(test_enable_respawn_detection_params)):
	# given
	var mock_collision_area = double(Area2D).new()
	respawn_manager.onready_paths.collision_detection_area = mock_collision_area
	stub(mock_collision_area, "set_deferred").to_do_nothing()
	# when
	respawn_manager.enable_respawn_detection(params[0])
	# then
	assert_called(mock_collision_area, "set_deferred", ["monitoring", params[0]])
	assert_called(mock_collision_area, "set_deferred", ["monitorable", params[0]])

func test_start_respawn_timer():
	# given
	var mock_timer = double(Timer).new()
	respawn_manager.onready_paths.respawn_timer = mock_timer
	stub(mock_timer, "start").to_do_nothing()
	# when
	respawn_manager.start_respawn_timer()
	# then
	assert_called(mock_timer, "start")

var test_has_obstacles_in_area_params := [
	[true],
	[false]
]
func test_has_obstacles_in_area(params = use_parameters(test_has_obstacles_in_area_params)):
	# given
	var mock_collision_area = double(Area2D).new()
	respawn_manager.onready_paths.collision_detection_area = mock_collision_area
	stub(mock_collision_area, "has_overlapping_bodies").to_return(params[0])
	# when
	var result_with_obstacles = respawn_manager._has_obstacles_in_area()
	# then
	assert_eq(result_with_obstacles, params[0])

func test_check_and_respawn_with_obstacles():
	# given
	var mock_collision_area = double(Area2D).new()
	var mock_wait_timer = double(Timer).new()
	respawn_manager.onready_paths.collision_detection_area = mock_collision_area
	respawn_manager.onready_paths.wait_respawn_timer = mock_wait_timer
	stub(mock_collision_area, "has_overlapping_bodies").to_return(true)
	stub(mock_wait_timer, "start").to_do_nothing()
	# when
	respawn_manager._check_and_respawn()
	# then
	assert_called(mock_wait_timer, "start")
	assert_called(mock_collision_area, "has_overlapping_bodies")

func test_check_and_respawn_without_obstacles():
	# given
	var mock_collision_area = double(Area2D).new()
	respawn_manager.onready_paths.collision_detection_area = mock_collision_area
	stub(mock_collision_area, "has_overlapping_bodies").to_return(false)
	respawn_manager.connect("wall_respawned", _on_respawn_manager_wall_respawned)
	# when
	respawn_manager._check_and_respawn()
	# then
	assert_true(wall_respawned_called)
	assert_called(mock_collision_area, "has_overlapping_bodies")

func test_on_respawn_timer_timeout():
	# given
	var mock_respawn_manager = partial_double(load("res://Scenes/DestructibleWalls/respawn_manager.gd")).new()
	stub(mock_respawn_manager, "_check_and_respawn").to_do_nothing()
	# when
	mock_respawn_manager._on_respawn_timer_timeout()
	# then
	assert_called(mock_respawn_manager, "_check_and_respawn")

func test_on_wait_respawn_timer_timeout():
	# given
	var mock_respawn_manager = partial_double(load("res://Scenes/DestructibleWalls/respawn_manager.gd")).new()
	stub(mock_respawn_manager, "_check_and_respawn").to_do_nothing()
	# when
	mock_respawn_manager._on_wait_respawn_timer_timeout()	
	# then
	assert_called(mock_respawn_manager, "_check_and_respawn")

##### UTILS #####
func _on_respawn_manager_wall_respawned():
	wall_respawned_called = true
