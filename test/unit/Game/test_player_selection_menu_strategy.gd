extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var players_ready_times_called := 0
var players_ready_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/GameManagers/player_selection_menu_strategy.gd").new()
	players_ready_times_called = 0
	players_ready_args = []

##### TEARDOWN #####
func after_each():
	menu.free()

##### TESTS #####
# reset mostly queue_free and not interacting well with gdunit

func test_init_offline():
	# given
	# when
	menu.init_offline()
	# then
	assert_eq(menu.get_child_count(), 1)
	var child_menu = menu.get_children()[0]
	assert_not_null(child_menu)
	assert_eq(child_menu.name, "PlayerSelectionMenu")
	assert_true(child_menu.is_connected("players_ready", menu._on_offline_players_ready))
	# cleanup
	child_menu.free()

func test_init_host():
	# given
	# when
	menu.init_host()
	# then
	assert_eq(menu.get_child_count(), 1)
	var child_menu = menu.get_children()[0]
	assert_not_null(child_menu)
	assert_eq(child_menu.name, "HostWaitingSelectionMenu")
	assert_true(child_menu.is_connected("all_players_ready", menu._on_host_everyone_ready))
	# cleanup
	child_menu.free()

func test_init_client():
	# given
	# when
	menu.init_client()
	# then
	assert_eq(menu.get_child_count(), 1)
	var child_menu = menu.get_children()[0]
	assert_not_null(child_menu)
	assert_eq(child_menu.name, "OnlinePlayerSelectionMenu")
	assert_true(child_menu.is_connected("player_ready", menu._on_online_player_ready))
	# cleanup
	child_menu.free()

func test_add_player_connected():
	# given
	var host_menu = double(load("res://Scenes/UI/PlayerCustomizationMenu/host_waiting_selection_menu.gd")).new()
	stub(host_menu, "add_connected_player").to_do_nothing()
	menu._menu = host_menu
	# when
	menu.add_player_connected()
	# then
	assert_called(host_menu, "add_connected_player")

var remove_player_connected_params := [
	[ {}, false],
	[ {1: "test"}, true]
]
func test_remove_player_connected(params = use_parameters(remove_player_connected_params)):
	# given
	var player_configs = params[0]
	var player_was_ready = params[1]
	var host_menu = double(load("res://Scenes/UI/PlayerCustomizationMenu/host_waiting_selection_menu.gd")).new()
	stub(host_menu, "remove_connected_player").to_do_nothing()
	menu._menu = host_menu
	menu._player_configs = player_configs
	# when
	menu.remove_player_connected(1)
	# then
	assert_called(host_menu, "remove_connected_player", [player_was_ready])

func test_add_player_ready():
	# given
	var dict = {"test": "Groovy Gary"}
	var host_menu = double(load("res://Scenes/UI/PlayerCustomizationMenu/host_waiting_selection_menu.gd")).new()
	stub(host_menu, "add_player_ready").to_do_nothing()
	menu._menu = host_menu
	# when
	menu._add_player_ready(1, dict)
	# then
	assert_eq(menu._player_configs[1], dict)
	assert_called(host_menu, "add_player_ready")

func test_on_offline_players_ready():
	# given
	var player_config_1 = PlayerConfig.new()
	var sprite_customization_1 = SpriteCustomizationResource.new()
	player_config_1.ELIMINATION_TEXT = "test 1"
	player_config_1.SPRITE_CUSTOMIZATION = sprite_customization_1
	var player_config_2 = PlayerConfig.new()
	var sprite_customization_2 = SpriteCustomizationResource.new()
	player_config_2.ELIMINATION_TEXT = "test 2"
	player_config_2.SPRITE_CUSTOMIZATION = sprite_customization_2
	var player_configs = [
		player_config_1,
		player_config_2
	]
	menu.connect("players_ready", _on_players_ready)
	# when
	menu._on_offline_players_ready(player_configs)
	# then
	assert_eq(players_ready_times_called, 1)
	var player_configs_args = players_ready_args[0][0]
	assert_eq(player_configs_args[0]["elimination_text"], "test 1")
	assert_eq(player_configs_args[1]["elimination_text"], "test 2")

# on_online_player_ready hard to test since it is a single rpc request

func test_on_host_everyone_ready():
	# given
	var player_configs = {"test": "test"}
	menu._player_configs = player_configs
	menu.connect("players_ready", _on_players_ready)
	# when
	menu._on_host_everyone_ready()
	# then
	assert_eq(players_ready_times_called, 1)
	assert_eq(players_ready_args[0][0], player_configs)

##### UTILS  #####
func _on_players_ready(players_config: Dictionary) -> void:
	players_ready_times_called += 1
	players_ready_args.append([players_config])
