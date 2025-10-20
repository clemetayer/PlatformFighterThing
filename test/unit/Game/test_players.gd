extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var players
var lives_updated_times_called := 0
var lives_updated_args := []
var player_won_times_called := 0
var player_won_args := []
var powerup_updated_times_called := 0
var powerup_updated_args := []
var movement_updated_times_called := 0
var movement_updated_args := []
var game_message_triggered_times_called := 0
var game_message_triggered_args := []

##### SETUP #####
func before_all():
	pass

func before_each():
	players = load("res://Scenes/Game/players.gd").new()
	lives_updated_times_called = 0
	lives_updated_args = []
	player_won_times_called = 0
	player_won_args = []
	powerup_updated_times_called = 0
	powerup_updated_args = []
	movement_updated_times_called = 0
	movement_updated_args = []
	game_message_triggered_times_called = 0
	game_message_triggered_args = []

##### TEARDOWN #####
func after_all():
	pass

func after_each():
	players.free()

##### TESTS #####
func test_init_players_data():
	# given
	var player_1_data = {
		"config": {
			"action_handler":StaticActionHandler.handlers.INPUT,
			"primary_weapon":StaticPrimaryWeaponHandler.handlers.REVOLVER,
			"movement_bonus_handler":StaticMovementBonusHandler.handlers.DASH,
			"powerup_handler":StaticPowerupHandler.handlers.SPLITTER,
			"sprite_customization": {
				"body_color":Color.ALICE_BLUE.to_html(),
				"outline_color":Color.ANTIQUE_WHITE.to_html()
			},
			"elmination_text":"test"
		}
	}
	var player_2_data = {
		"config": {
			"action_handler":StaticActionHandler.handlers.RECORD,
			"primary_weapon":StaticPrimaryWeaponHandler.handlers.REVOLVER,
			"movement_bonus_handler":StaticMovementBonusHandler.handlers.DASH,
			"powerup_handler":StaticPowerupHandler.handlers.SPLITTER,
			"sprite_customization": {
				"body_color":Color.REBECCA_PURPLE.to_html(),
				"outline_color":Color.TURQUOISE.to_html()
			},
			"elmination_text":"test2"
		}
	}
	var player_1_data_deserialized = PlayerConfig.new()
	player_1_data_deserialized.deserialize(player_1_data.config)
	var player_2_data_deserialized = PlayerConfig.new()
	player_2_data_deserialized.deserialize(player_2_data.config)
	# when
	players.init_players_data({
		1:player_1_data,
		2:player_2_data
	})
	# then
	assert_eq(players._players_data.size(), 2)
	assert_eq(players._players_data[1].lives, players.BASE_LIVES_AMOUNT)
	compare_player_configs(players._players_data[1].config, player_1_data_deserialized)
	assert_eq(players._players_data[2].lives, players.BASE_LIVES_AMOUNT)
	compare_player_configs(players._players_data[2].config, player_2_data_deserialized)

func test_init_spawn_positions():
	# given
	players._current_spawn_idx = 10
	var spawn_positions = [Vector2.RIGHT, Vector2.DOWN]
	# when
	players.init_spawn_positions(spawn_positions)
	# then
	assert_eq(players._current_spawn_idx, 0)
	assert_eq(players._spawn_positions, spawn_positions)

var toggle_player_truce_params := [
	[true],
	[false]
]
func test_toggle_players_truce(params = use_parameters(toggle_player_truce_params)):
	# given
	players._players_data = {
		1:{},
		2:{}
	}
	var player_1_mock = double(load("res://Scenes/Player/player.gd")).new()
	player_1_mock.name = "player_1"
	stub(player_1_mock, "toggle_truce").to_do_nothing()
	players.add_child(player_1_mock)
	var player_2_mock = double(load("res://Scenes/Player/player.gd")).new()
	player_2_mock.name = "player_2"
	stub(player_2_mock, "toggle_truce").to_do_nothing()
	players.add_child(player_2_mock)
	# when
	players.toggle_players_truce(params[0])
	# then
	assert_called(player_1_mock,"toggle_truce", [params[0]])
	assert_called(player_2_mock,"toggle_truce", [params[0]])

func test_reset():
	# given
	players._players_data = {
		1:{},
		2:{}
	}
	# when
	players.reset()
	# then
	assert_eq(players._players_data, {})
	# won't test clean players because queue_free not works well with GUT

func test_add_players():
	# given
	players._spawn_positions = [Vector2.RIGHT, Vector2.UP]
	players._players_data = {
		1:{},
		2:{}
	}
	# when
	players.add_players()
	wait_seconds(0.25)
	# then
	assert_eq(players.get_child_count(),2)
	for player_idx in range(1,3):
		var player = players.get_node_or_null("player_%d" % player_idx)
		assert_not_null(player)
		assert_eq(player.id,player_idx)
		assert_eq(player.global_position,players._spawn_positions[player_idx-1])
		assert_true(player.is_connected("killed",players._on_player_killed))
		assert_true(player.is_connected("movement_updated",players._on_player_movement_updated))
		assert_true(player.is_connected("powerup_updated",players._on_player_powerup_updated))
		assert_true(player.is_connected("game_message_triggered",players._on_player_game_message_triggered))

func test_get_player_instance():
	# given
	var node = Node2D.new()
	node.name = "player_1"
	players.add_child(node)
	wait_for_signal(node.tree_entered,0.25)
	# when
	var res = players.get_player_instance(1)
	# then
	assert_eq(res,node)
	# cleanup
	node.free()

func test_get_player_config():
	# given
	var config = PlayerConfig.new()
	players._players_data = {
		1 : {
			"config": config
		}
	}
	# when
	var res = players.get_player_config(1)
	# then
	assert_eq(res, config)

func test_get_players_data():
	# given
	var data = {
		1 : {},
		2 : {}
	}
	players._players_data = data
	# when
	var res = players.get_players_data()
	# then
	assert_eq(res, data)

func test_spawn_player():
	# given
	players._players_data = {
		1:{},
		2:{}
	}
	# when
	players._spawn_player(1,Vector2.LEFT)
	wait_seconds(0.25)
	# then
	assert_eq(players.get_child_count(),1)
	var player = players.get_node_or_null("player_%d" % 1)
	assert_not_null(player)
	assert_eq(player.id,1)
	assert_eq(player.global_position,Vector2.LEFT)
	assert_true(player.is_connected("killed",players._on_player_killed))
	assert_true(player.is_connected("movement_updated",players._on_player_movement_updated))
	assert_true(player.is_connected("powerup_updated",players._on_player_powerup_updated))
	assert_true(player.is_connected("game_message_triggered",players._on_player_game_message_triggered))

func test_get_spawn_position_and_go_next():
	# given
	players._spawn_positions = [Vector2.RIGHT, Vector2.LEFT]
	# when
	var res1 = players._get_spawn_position_and_go_next()
	var res2 = players._get_spawn_position_and_go_next()
	var res3 = players._get_spawn_position_and_go_next()
	# then
	assert_eq(res1, Vector2.RIGHT)
	assert_eq(res2, Vector2.LEFT)
	assert_eq(res3, Vector2.RIGHT)

var is_only_one_player_alive_params := [
	[
		{
			1:{"lives":2},
			2:{"lives":1},
			3:{"lives":4}
		},
		false
	],
	[
		{
			1:{"lives":0},
			2:{"lives":1},
			3:{"lives":4}
		},
		false
	],
	[
		{
			1:{"lives":0},
			2:{"lives":0},
			3:{"lives":4}
		},
		true
	],
	[
		{
			1:{"lives":0},
			2:{"lives":0},
			3:{"lives":0}
		},
		true
	],
	[
		{
			1:{"lives":1}
		},
		true
	],
]
func test_is_only_one_player_alive(params = use_parameters(is_only_one_player_alive_params)):
	# given
	players._players_data = params[0]
	# when
	var res = players._is_only_one_player_alive()
	# then
	assert_eq(res,params[1])

func test_on_player_killed_not_end_game():
	# given
	players._players_data = {
		1: {
			"lives":2
		},
		2: {
			"lives":3
		}
	}
	players.connect("lives_updated",_on_lives_updated)
	players.connect("player_won",_on_player_won)
	var tree_mock = double(SceneTree).new()
	var timer = Timer.new()
	add_child_autofree(timer)
	timer.start(players.RESPAWN_TIME + 0.1)
	stub(tree_mock,"create_timer").to_return(timer)
	players.tree = tree_mock
	wait_seconds(players.RESPAWN_TIME + 0.25)
	# when
	players._on_player_killed(1)
	# then
	assert_eq(lives_updated_times_called, 1)
	assert_eq(lives_updated_args, [[1, 1]])
	assert_eq(player_won_times_called, 0)
	assert_eq(players._players_data[1].lives,1)
	assert_eq(players._players_data[2].lives,3)
	# cleanup 
	timer.free()

func test_on_player_killed_end_game():
	# given
	players._players_data = {
		1: {
			"lives":2
		},
		2: {
			"lives":1
		}
	}
	players.connect("lives_updated",_on_lives_updated)
	players.connect("player_won",_on_player_won)
	# when
	players._on_player_killed(2)
	# then
	assert_eq(lives_updated_times_called, 1)
	assert_eq(lives_updated_args, [[2, 0]])
	assert_eq(player_won_times_called, 1)
	assert_eq(players._players_data[1].lives,2)
	assert_eq(players._players_data[2].lives,0)

func test_on_player_movement_updated():
	# given
	players.connect("movement_updated", _on_movement_updated)
	# when
	players._on_player_movement_updated(1,2)
	# then
	assert_eq(movement_updated_times_called,1)
	assert_eq(movement_updated_args, [[1,2]])

func test_on_player_powerup_updated():
	# given
	players.connect("powerup_updated", _on_powerup_updated)
	# when 
	players._on_player_powerup_updated(2,0.5)
	# then
	assert_eq(powerup_updated_times_called,1)
	assert_eq(powerup_updated_args, [[2,0.5]])

func test_on_player_game_message_triggered():
	# given
	var config = PlayerConfig.new()
	config.ELIMINATION_TEXT = "test"
	players._players_data = {
		1: {
			"config":config
		}
	}
	players.connect("game_message_triggered",_on_game_message_triggered)
	# when
	players._on_player_game_message_triggered(1)
	# then
	assert_eq(game_message_triggered_times_called,1)
	assert_eq(game_message_triggered_args,[["test"]])

##### UTILS #####
func _on_lives_updated(player_idx: int, new_value: int) -> void:
	lives_updated_times_called += 1
	lives_updated_args.append([player_idx, new_value])

func _on_player_won() -> void:
	player_won_times_called += 1
	player_won_args.append([])

func _on_powerup_updated(player_idx: int, new_value) -> void:
	powerup_updated_times_called += 1
	powerup_updated_args.append([player_idx, new_value])

func _on_movement_updated(player_id: int, value) -> void:
	movement_updated_times_called += 1
	movement_updated_args.append([player_id, value])

func _on_game_message_triggered(message: String) -> void:
	game_message_triggered_times_called += 1
	game_message_triggered_args.append([message])

func compare_player_configs(conf1 : PlayerConfig, conf2 : PlayerConfig) -> void:
	assert_eq(conf1.ACTION_HANDLER,conf2.ACTION_HANDLER)
	assert_eq(conf1.PRIMARY_WEAPON,conf2.PRIMARY_WEAPON)
	assert_eq(conf1.MOVEMENT_BONUS_HANDLER,conf2.MOVEMENT_BONUS_HANDLER)
	assert_eq(conf1.POWERUP_HANDLER,conf2.POWERUP_HANDLER)
	assert_eq(conf1.SPRITE_CUSTOMIZATION.BODY_COLOR,conf2.SPRITE_CUSTOMIZATION.BODY_COLOR)
	assert_eq(conf1.SPRITE_CUSTOMIZATION.OUTLINE_COLOR,conf2.SPRITE_CUSTOMIZATION.OUTLINE_COLOR)
	assert_eq(conf1.ELIMINATION_TEXT,conf2.ELIMINATION_TEXT) 
