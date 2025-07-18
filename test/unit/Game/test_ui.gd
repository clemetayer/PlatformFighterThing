extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var ui
var clean_times_called := 0
var add_player_times_called := 0
var add_player_args := []
var update_movement_times_called := 0 
var update_movement_args := []
var update_powerup_times_called := 0
var update_powerup_args := []
var update_lives_times_called := 0
var update_lives_args := []
var display_message_times_called := 0
var display_message_args := []
var time_over_emitted := false

##### SETUP #####
func before_each():
	ui = load("res://Scenes/Game/ui.gd").new()
	clean_times_called = 0
	add_player_times_called = 0
	add_player_args = []
	update_movement_times_called = 0 
	update_movement_args = []
	update_powerup_times_called = 0
	update_powerup_args = []
	update_lives_times_called = 0
	update_lives_args = []
	display_message_times_called = 0
	display_message_args = []
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
	var players_data = {1: {"config": player_1_config, "lives": 5}, 2: {"config": player_2_config, "lives": 10}}
	var mock_game_ui = load("res://test/unit/Game/test_ui_mocks/players_data_ui_mock.gd").new()
	mock_game_ui.connect("add_player_called", _on_game_ui_add_player_called)
	mock_game_ui.connect("update_lives_called", _on_game_ui_update_lives_called)
	mock_game_ui.connect("clean_called", _on_game_ui_clean_called)
	ui.onready_paths.game_ui = mock_game_ui
	add_child(mock_game_ui)
	wait_for_signal(mock_game_ui.tree_entered, 0.25)
	mock_game_ui.hide()
	# when
	ui.init_game_ui(players_data)
	# then
	assert_true(ui.onready_paths.game_ui.visible)
	assert_eq(clean_times_called, 1)
	assert_eq(add_player_times_called,2)
	assert_eq(add_player_args, [
		[1,player_1_config,5],
		[2,player_2_config,10]
	])
	assert_eq(update_lives_times_called,2)
	assert_eq(update_lives_args, [
		[1,5],
		[2,10]
	])
	# cleanup
	mock_game_ui.free()

func test_init_chronometer():
	# given
	var game_time = 30.0
	var mock_chronometer = double(load("res://Scenes/UI/Chronometer/chronometer.gd")).new()
	stub(mock_chronometer, "start_timer").to_do_nothing()
	ui.onready_paths.chronometer = mock_chronometer
	# when
	ui.init_chronometer(game_time)
	# then
	assert_true(ui.onready_paths.chronometer.is_connected("time_over", ui._on_chronometer_time_over))
	assert_called(mock_chronometer, "start_timer", [game_time])
	assert_true(mock_chronometer.visible)

func test_init_screen_game_message():
	# given
	var mock_screen_message = double(load("res://Scenes/UI/ScreenGameMessage/screen_game_message.gd")).new()
	stub(mock_screen_message,"init").to_do_nothing()
	ui.onready_paths.screen_message = mock_screen_message
	# when
	ui.init_screen_game_message()
	# then
	assert_true(ui.onready_paths.screen_message.is_visible())
	assert_called(mock_screen_message,"init")

func test_update_movement():
	# given
	var player_id = 1
	var value = 10.0 
	var mock_game_ui = load("res://test/unit/Game/test_ui_mocks/players_data_ui_mock.gd").new()
	mock_game_ui.connect("update_movement_called", _on_game_ui_update_movement_called)
	ui.onready_paths.game_ui = mock_game_ui
	add_child(mock_game_ui)
	wait_for_signal(mock_game_ui.tree_entered, 1)
	# when
	ui.update_movement(player_id, value)
	# then
	assert_eq(update_movement_times_called,1)
	assert_eq(update_movement_args,[
		[1,10.0]
	])
	# cleanup
	mock_game_ui.free()

func test_update_powerup():
	# given
	var player_id = 1
	var value = 10.0 
	var mock_game_ui = load("res://test/unit/Game/test_ui_mocks/players_data_ui_mock.gd").new()
	mock_game_ui.connect("update_powerup_called", _on_game_ui_update_powerup_called)
	ui.onready_paths.game_ui = mock_game_ui
	add_child(mock_game_ui)
	wait_for_signal(mock_game_ui.tree_entered, 1)
	# when
	ui.update_powerup(player_id, value)
	# then
	assert_eq(update_powerup_times_called,1)
	assert_eq(update_powerup_args,[
		[1,10.0]
	])
	# cleanup
	mock_game_ui.free()

func test_update_lives():
	# given
	var player_id = 1
	var value = 10
	var mock_game_ui = load("res://test/unit/Game/test_ui_mocks/players_data_ui_mock.gd").new()
	mock_game_ui.connect("update_lives_called", _on_game_ui_update_lives_called)
	ui.onready_paths.game_ui = mock_game_ui
	add_child(mock_game_ui)
	wait_for_signal(mock_game_ui.tree_entered, 1)
	# when
	ui.update_lives(player_id, value)
	# then
	assert_eq(update_lives_times_called,1)
	assert_eq(update_lives_args,[
		[1,10]
	])
	# cleanup 
	mock_game_ui.free()

func test_display_message():
	# given
	var message = "Hello, World!"
	var display_all_characters = true
	var mock_screen_message = load("res://test/unit/Game/test_ui_mocks/screen_message_mock.gd").new()
	mock_screen_message.connect("display_message_called", _on_screen_message_display_message_called)
	ui.onready_paths.screen_message = mock_screen_message
	add_child(mock_screen_message)
	wait_for_signal(mock_screen_message.tree_entered, 1) 
	# when
	ui.display_message(message, display_all_characters)
	# then
	assert_eq(display_message_times_called, 1)
	assert_eq(display_message_args[0][0], message)
	assert_eq(display_message_args[0][1], ui.PLAYER_GAME_MESSAGE_DURATION)
	assert_eq(display_message_args[0][2], display_all_characters)
	# cleanup
	mock_screen_message.free()

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
func test__on_chronometer_time_over():
	# given
	ui.connect("time_over",_on_ui_time_over)
	# when
	ui._on_chronometer_time_over()
	# then
	assert_true(time_over_emitted)

##### UTILS #####
func _on_game_ui_clean_called() -> void:
	clean_times_called += 1

func _on_game_ui_add_player_called(player_id: int, config: PlayerConfig, lives: int) -> void:
	add_player_times_called += 1
	add_player_args.append([player_id, config, lives])

func _on_game_ui_update_movement_called(player_id: int, value) -> void: 
	update_movement_times_called += 1
	update_movement_args.append([player_id, value])

func _on_game_ui_update_powerup_called(player_id: int, value) -> void:
	update_powerup_times_called += 1
	update_powerup_args.append([player_id, value])

func _on_game_ui_update_lives_called(player_id: int, value) -> void:
	update_lives_times_called += 1
	update_lives_args.append([player_id, value])

func _on_screen_message_display_message_called(message: String, duration: float, display_all_characters : bool) -> void:
	display_message_times_called += 1
	display_message_args.append([message, duration, display_all_characters])

func _on_ui_time_over() -> void:
	time_over_emitted = true
