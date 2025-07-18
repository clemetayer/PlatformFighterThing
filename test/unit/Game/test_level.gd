extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var level

##### SETUP #####
func before_each():
	level = load("res://Scenes/Game/level.gd").new()

##### TEARDOWN #####
func after_each():
	level.free()

##### TESTS #####
func test_init_level_data():
	# given
	var level_data = {
		"background_and_music": "res://test/unit/Game/test_level_mocks/background_and_music.tscn",
		"level_path": "res://test/unit/Game/test_level_mocks/level.tscn"
	}
	# when
	level.init_level_data(level_data)
	# then
	assert_eq(level._level_data.background_and_music, level_data.background_and_music)
	assert_eq(level._level_data.level_path, level_data.level_path)

func test_add_level():
	# given
	var level_data = {
		"background_and_music": "res://test/unit/Game/test_level_mocks/background_and_music.tscn",
		"level_path": "res://test/unit/Game/test_level_mocks/level.tscn"
	}
	level.init_level_data(level_data)
	add_child(level)
	wait_for_signal(level.tree_entered, 0.25)
	# when
	level.add_level()
	# then
	wait_seconds(0.25)
	assert_eq(level.get_child_count(),1)
	assert_eq(level._spawn_positions, [Vector2(-10.0,5.0),Vector2(8.0,-12.0)])

# won't test reset because queue_free() does not work well with GUT

func test_get_spawn_positions():
	# given
	level._spawn_positions = [Vector2.RIGHT,Vector2.LEFT]
	# when
	var spawn_positions = level.get_spawn_positions()
	# then
	assert_eq(spawn_positions, [Vector2.RIGHT,Vector2.LEFT])

func test_get_background_path():
	# given
	var level_config = LevelConfig.new()
	level_config.background_and_music = "res://test/unit/Game/test_level_mocks/background_and_music.tscn"
	level._level_data = level_config
	# when
	var background_path = level.get_background_path()
	# then
	assert_eq(background_path, "res://test/unit/Game/test_level_mocks/background_and_music.tscn")

# _spawn_level pretty much already tested in add_level
