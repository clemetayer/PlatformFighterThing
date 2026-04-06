extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var ui
var time_over_emitted := false


##### SETUP #####
func before_each():
	ui = load("res://Scenes/Game/ui.gd").new()
	time_over_emitted = false


##### TEARDOWN #####
func after_each():
	ui.free()


##### TESTS #####
func test_init_game_ui():
	# given
	var player_1_config = PlayerConfig.new()
	player_1_config.ELIMINATION_TEXT = "player_1"
	var player_2_config = PlayerConfig.new()
	player_2_config.ELIMINATION_TEXT = "player_2"
	var players_data = { 1: { "config": player_1_config, "lives": 5 }, 2: { "config": player_2_config, "lives": 10 } }
	var mock_game_ui = double(load("res://Scenes/UI/PlayersData/players_data_ui.gd")).new()
	stub(mock_game_ui, "add_player").to_do_nothing()
	stub(mock_game_ui, "update_lives").to_do_nothing()
	stub(mock_game_ui, "clean").to_do_nothing()
	ui.onready_paths.game_ui = mock_game_ui
	mock_game_ui.hide()
	# when
	ui.init_game_ui(players_data)
	# then
	assert_true(ui.onready_paths.game_ui.visible)
	assert_called(mock_game_ui, "clean")
	assert_called(mock_game_ui, "add_player", [1, player_1_config, 5])
	assert_called(mock_game_ui, "add_player", [2, player_2_config, 10])
	assert_called_count(mock_game_ui.add_player, 2)
	assert_called(mock_game_ui, "update_lives", [1, 5])
	assert_called(mock_game_ui, "update_lives", [2, 10])
	assert_called_count(mock_game_ui.update_lives, 2)


func test_init_chronometer():
	# given
	var game_time = 30.0
	var mock_chronometer = double(load("res://Scenes/UI/Chronometer/chronometer.gd"), DOUBLE_STRATEGY.INCLUDE_NATIVE).new()
	stub(mock_chronometer, "start_timer").to_do_nothing()
	stub(mock_chronometer, "connect").to_do_nothing()
	ui.onready_paths.chronometer = mock_chronometer
	# when
	ui.init_chronometer(game_time)
	# then
	assert_called(mock_chronometer, "connect", ["time_over", ui._on_chronometer_time_over, null])
	assert_called(mock_chronometer, "start_timer", [game_time])
	assert_true(mock_chronometer.visible)


func test_init_screen_game_message():
	# given
	var mock_screen_message = double(load("res://Scenes/UI/ScreenGameMessage/screen_game_message.gd")).new()
	stub(mock_screen_message, "init").to_do_nothing()
	ui.onready_paths.screen_message = mock_screen_message
	# when
	ui.init_screen_game_message()
	# then
	assert_true(ui.onready_paths.screen_message.is_visible())
	assert_called(mock_screen_message, "init")


func test_update_movement():
	# given
	var player_id = 1
	var value = 10.0
	var mock_game_ui = double(load("res://Scenes/UI/PlayersData/players_data_ui.gd")).new()
	stub(mock_game_ui, "update_movement").to_do_nothing()
	ui.onready_paths.game_ui = mock_game_ui
	# when
	ui.update_movement(player_id, value)
	# then
	assert_called(mock_game_ui, "update_movement", [1, 10.0])


func test_update_powerup():
	# given
	var player_id = 1
	var value = 10.0
	var mock_game_ui = double(load("res://Scenes/UI/PlayersData/players_data_ui.gd")).new()
	stub(mock_game_ui, "update_powerup").to_do_nothing()
	ui.onready_paths.game_ui = mock_game_ui
	# when
	ui.update_powerup(player_id, value)
	# then
	assert_called(mock_game_ui, "update_powerup", [1, 10.0])


func test_update_lives():
	# given
	var player_id = 1
	var value = 10
	var mock_game_ui = double(load("res://Scenes/UI/PlayersData/players_data_ui.gd")).new()
	stub(mock_game_ui, "update_lives").to_do_nothing()
	ui.onready_paths.game_ui = mock_game_ui
	# when
	ui.update_lives(player_id, value)
	# then
	assert_called(mock_game_ui, "update_lives", [1, 10])


func test_display_message():
	# given
	var message = "Hello, World!"
	var display_all_characters = true
	var mock_screen_message = double(load("res://Scenes/UI/ScreenGameMessage/screen_game_message.gd")).new()
	stub(mock_screen_message, "display_message").to_do_nothing()
	ui.onready_paths.screen_message = mock_screen_message
	# when
	ui.display_message(message, display_all_characters)
	# then
	assert_called(mock_screen_message, "display_message", [message, ui.PLAYER_GAME_MESSAGE_DURATION, display_all_characters])


func test_reset():
	# given
	var mock_game_ui = double(load("res://Scenes/UI/PlayersData/players_data_ui.gd"), DOUBLE_STRATEGY.INCLUDE_NATIVE).new()
	stub(mock_game_ui, "clean").to_do_nothing()
	stub(mock_game_ui, "hide").to_do_nothing()
	ui.onready_paths.game_ui = mock_game_ui
	var mock_chronometer = double(load("res://Scenes/UI/Chronometer/chronometer.gd"), DOUBLE_STRATEGY.INCLUDE_NATIVE).new()
	stub(mock_chronometer, "hide").to_do_nothing()
	ui.onready_paths.chronometer = mock_chronometer
	var mock_screen_message = double(load("res://Scenes/UI/ScreenGameMessage/screen_game_message.gd"), DOUBLE_STRATEGY.INCLUDE_NATIVE).new()
	stub(mock_screen_message, "hide").to_do_nothing()
	ui.onready_paths.screen_message = mock_screen_message
	# when
	ui.reset()
	# then
	assert_called(mock_game_ui, "clean")
	assert_called(mock_game_ui, "hide")
	assert_called(mock_chronometer, "hide")
	assert_called(mock_screen_message, "hide")


# Tests pour _on_chronometer_time_over
func test_on_chronometer_time_over():
	# given
	ui.connect("time_over", _on_ui_time_over)
	# when
	ui._on_chronometer_time_over()
	# then
	assert_true(time_over_emitted)


##### UTILS #####
func _on_ui_time_over() -> void:
	time_over_emitted = true
