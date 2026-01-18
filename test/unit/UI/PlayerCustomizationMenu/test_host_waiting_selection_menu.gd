extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var all_players_ready_times_called := 0

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/host_waiting_selection_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)
	all_players_ready_times_called = 0

##### TESTS #####
func test_add_connected_player():
	# given
	# when
	menu.add_connected_player()
	# then
	assert_eq(menu._connected_players, 1)
	assert_eq(menu.onready_paths.label.text, menu.PLAYERS_CONNECTED_LABEL % [0, 1])

var remove_connected_player_params := [
	[true],
	[false]
]
func test_remove_connected_player(params = use_parameters(remove_connected_player_params)):
	# given
	var player_was_ready = params[0]
	menu._connected_players = 2
	menu._players_ready = 1
	# when
	menu.remove_connected_player(player_was_ready)
	# then
	assert_eq(menu._connected_players, 1)
	assert_eq(menu._players_ready, 0 if player_was_ready else 1)
	assert_eq(menu.onready_paths.label.text, menu.PLAYERS_CONNECTED_LABEL % [0 if player_was_ready else 1, 1])

func test_add_player_ready():
	# given
	menu._connected_players = 1
	# when
	menu.add_player_ready()
	# then
	assert_eq(menu._players_ready, 1)
	assert_eq(menu.onready_paths.label.text, menu.PLAYERS_CONNECTED_LABEL % [1, 1])

# update_label already tested

var check_if_everyone_ready_params := [
	[0, 0],
	[1, 0],
	[1, 1]
]
func test_check_if_everyone_ready(params = use_parameters(check_if_everyone_ready_params)):
	# given
	var connected_players = params[0]
	var players_ready = params[1]
	menu._connected_players = connected_players
	menu._players_ready = players_ready
	menu.connect("all_players_ready", _on_all_players_ready)
	# when
	menu._check_if_everyone_ready()
	# then
	if connected_players > 0 and connected_players == players_ready:
		assert_eq(all_players_ready_times_called, 1)
	else:
		assert_eq(all_players_ready_times_called, 0)

##### UTILS #####
func _on_all_players_ready() -> void:
	all_players_ready_times_called += 1
