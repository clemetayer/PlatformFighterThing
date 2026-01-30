extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var button
var player_type_changed_times_called := 0
var player_type_changed_args := []

##### SETUP #####
func before_each():
	button = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/player_type_button.gd").new()
	player_type_changed_times_called = 0
	player_type_changed_args = []


##### TEARDOWN #####
func after_each():
	if is_instance_valid(button):
		button.free()

##### TESTS #####
func test_ready():
	# given
	add_child_autofree(button)
	await wait_for_signal(button.tree_entered, 0.1)
	# when
	button._ready()
	# then
	assert_not_null(button.icon)
	assert_eq(button.tooltip_text, button.PLAYER_TYPES_ICON_MAP[StaticActionHandler.handlers.INPUT].description)

var get_selected_handler_params := [
	[0, StaticActionHandler.handlers.INPUT],
	[1, StaticActionHandler.handlers.RECORD]
]
func test_get_selected_handler(params = use_parameters(get_selected_handler_params)):
	# given
	var player_type_idx = params[0]
	var expectation = params[1]
	button._current_player_type_idx = player_type_idx
	# when
	var res = button.get_selected_handler()
	# then
	assert_eq(res, expectation)

func test_reset():
	# given
	button._current_player_type_idx = 1
	button.connect("player_type_changed", _on_player_type_changed)
	# when
	button.reset()
	# then
	assert_eq(button._current_player_type_idx, 0)
	assert_not_null(button.icon)
	assert_eq(button.tooltip_text, button.PLAYER_TYPES_ICON_MAP[StaticActionHandler.handlers.INPUT].description)
	assert_eq(player_type_changed_times_called, 1)
	assert_eq(player_type_changed_args, [[StaticActionHandler.handlers.INPUT]])

var set_button_data_params := [
	[StaticActionHandler.handlers.INPUT],
	[StaticActionHandler.handlers.RECORD]
]
func test_set_button_data(params = use_parameters(set_button_data_params)):
	# given
	var player_type = params[0]
	# when
	button._set_button_data(player_type)
	# then
	assert_not_null(button.icon)
	assert_eq(button.tooltip_text, button.PLAYER_TYPES_ICON_MAP[player_type].description)

var on_pressed_params := [
	[0, 1, StaticActionHandler.handlers.RECORD],
	[1, 0, StaticActionHandler.handlers.INPUT]
]
func test_on_pressed(params = use_parameters(on_pressed_params)):
	# given
	var current_idx = params[0]
	var next_idx = params[1]
	var next_handler = params[2]
	button._current_player_type_idx = current_idx
	button.connect("player_type_changed", _on_player_type_changed)
	# when
	button._on_pressed()
	# then
	assert_eq(button._current_player_type_idx, next_idx)
	assert_not_null(button.icon)
	assert_eq(button.tooltip_text, button.PLAYER_TYPES_ICON_MAP[next_handler].description)
	assert_eq(player_type_changed_times_called, 1)
	assert_eq(player_type_changed_args, [[next_handler]])

##### UTILS #####
func _on_player_type_changed(player_type: StaticActionHandler.handlers) -> void:
	player_type_changed_times_called += 1
	player_type_changed_args.append([player_type])
