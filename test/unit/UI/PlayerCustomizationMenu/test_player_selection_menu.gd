extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var players_ready_times_called := 0
var players_ready_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/player_selection_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)
	players_ready_times_called = 0
	players_ready_args = []

##### TESTS #####
func test_get_players_config():
	# given
	var config1 = PlayerConfig.new()
	var item1 = create_player_selection_item_mock()
	stub(item1, "get_config").to_return(config1)
	var config2 = PlayerConfig.new()
	var item2 = create_player_selection_item_mock()
	stub(item2, "get_config").to_return(config2)
	var player_selection_items = double(Node).new()
	stub(player_selection_items, "get_children").to_return([item1, item2])
	menu.onready_paths.player_selection_items = player_selection_items
	# when
	var res = menu._get_players_config()
	# then
	assert_eq(res.size(), 2)
	assert_eq(res[0], config1)
	assert_eq(res[1], config2)

func test_on_start_button_button_up():
	# given
	var menu_mock = partial_double(load("res://Scenes/UI/PlayerCustomizationMenu/player_selection_menu.gd")).new()
	var configs = [PlayerConfig.new(), PlayerConfig.new()]
	stub(menu_mock, "_get_players_config").to_return(configs)
	menu_mock.connect("players_ready", _on_players_ready, 0)
	# when
	menu_mock._on_start_button_button_up()
	# then
	assert_eq(players_ready_times_called, 1)
	assert_eq(players_ready_args, [[configs]])

##### UTILS #####
func create_player_selection_item_mock():
	return double(load("res://Scenes/UI/PlayerCustomizationMenu/player_selection_item.gd")).new()

func _on_players_ready(players_configs: Array) -> void:
	players_ready_times_called += 1
	players_ready_args.append([players_configs])