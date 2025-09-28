extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_1_DEFAULT_CONFIG_PATH := "res://test/integration/UI/player_1.tres"
const PLAYER_2_DEFAULT_CONFIG_PATH := "res://test/integration/UI/player_2.tres"

#---- VARIABLES -----
var scene

##### SETUP #####
func before_each():
	scene = load("res://test/integration/UI/scene_ui.tscn").instantiate()
	add_child_autofree(scene)
	wait_process_frames(1)

##### TESTS #####
func test_init_two_players():
	# given
	var player_1_config = load(PLAYER_1_DEFAULT_CONFIG_PATH)
	var player_2_config = load(PLAYER_2_DEFAULT_CONFIG_PATH)
	# when / then
	var ui = scene.get_ui()
	ui.add_player(1,player_1_config,1)
	ui.add_player(2,player_2_config,3)
	await wait_process_frames(1)
	assert_eq(ui.get_child_count(), 2)
	assert_eq(ui._players.size(), 2)
	assert_eq(ui._players[1].onready_paths.sprites.body.modulate, player_1_config.SPRITE_CUSTOMIZATION.BODY_COLOR)
	assert_eq(ui._players[1].onready_paths.sprites.outline.modulate, player_1_config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR)
	assert_eq(ui._players[2].onready_paths.sprites.body.modulate, player_2_config.SPRITE_CUSTOMIZATION.BODY_COLOR)
	assert_eq(ui._players[2].onready_paths.sprites.outline.modulate, player_2_config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR)
	assert_eq(ui._players[1].onready_paths.name.text, "temporary_man")
	assert_eq(ui._players[2].onready_paths.name.text, "temporary_man")
	var p1_movement_icon_path = load(MovementDataUiSettings.data[player_1_config.MOVEMENT_BONUS_HANDLER]).ICON_PATH
	var p2_movement_icon_path = load(MovementDataUiSettings.data[player_2_config.MOVEMENT_BONUS_HANDLER]).ICON_PATH
	var p1_powerup_icon_path = load(PowerupDataUISettings.data[player_1_config.POWERUP_HANDLER]).ICON_PATH
	var p2_powerup_icon_path = load(PowerupDataUISettings.data[player_2_config.POWERUP_HANDLER]).ICON_PATH
	var p1_movement = ui._players[1]._movement_ui
	var p1_powerup = ui._players[1]._powerup_ui
	var p1_lives = ui._players[1]._lives_ui
	var p2_movement = ui._players[2]._movement_ui
	var p2_powerup = ui._players[2]._powerup_ui
	var p2_lives = ui._players[2]._lives_ui
	assert_not_null(p1_movement)
	assert_eq(p1_movement.DATA_ICON, p1_movement_icon_path)
	assert_not_null(p1_powerup)
	assert_eq(p1_powerup.DATA_ICON, p1_powerup_icon_path)
	assert_not_null(p1_lives)
	assert_eq(p1_lives.LIVES, 1)
	assert_not_null(p2_movement)
	assert_eq(p2_movement.DATA_ICON, p2_movement_icon_path)
	assert_not_null(p2_powerup)
	assert_eq(p2_powerup.DATA_ICON, p2_powerup_icon_path)
	assert_not_null(p2_lives)
	assert_eq(p2_lives.LIVES, 3)

func test_lives():
	# given
	var player_1_config = load(PLAYER_1_DEFAULT_CONFIG_PATH)
	var player_2_config = load(PLAYER_2_DEFAULT_CONFIG_PATH)
	# when / then
	var ui = scene.get_ui()
	ui.add_player(1,player_1_config,3)
	ui.add_player(2,player_2_config,3)
	await wait_process_frames(1)
	var p1_lives = ui._players[1]._lives_ui
	var p2_lives = ui._players[2]._lives_ui
	assert_eq(p1_lives.LIVES, 3)
	assert_eq(p1_lives.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p1_lives.onready_paths.tokens), 3)
	assert_eq(p1_lives.onready_paths.overflow.text, "")
	assert_eq(p2_lives.LIVES, 3)
	assert_eq(p2_lives.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p2_lives.onready_paths.tokens), 3)
	assert_eq(p2_lives.onready_paths.overflow.text, "")
	ui.update_lives(1,1)
	await wait_process_frames(1)
	assert_eq(p1_lives.LIVES, 1)
	assert_eq(p1_lives.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p1_lives.onready_paths.tokens), 1)
	assert_eq(p1_lives.onready_paths.overflow.text, "")
	assert_eq(p2_lives.LIVES, 3)
	assert_eq(p2_lives.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p2_lives.onready_paths.tokens), 3)
	assert_eq(p2_lives.onready_paths.overflow.text, "")

func test_dash():
	# given
	var player_1_config = load(PLAYER_1_DEFAULT_CONFIG_PATH)
	var player_2_config = load(PLAYER_2_DEFAULT_CONFIG_PATH)
	player_1_config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	player_2_config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	# when / then
	var ui = scene.get_ui()
	ui.add_player(1,player_1_config,1)
	ui.add_player(2,player_2_config,3)
	await wait_process_frames(1)
	ui.update_movement(1,3)
	ui.update_movement(2,3)
	var p1_movement_icon_path = load(MovementDataUiSettings.data[player_1_config.MOVEMENT_BONUS_HANDLER]).ICON_PATH
	var p2_movement_icon_path = load(MovementDataUiSettings.data[player_2_config.MOVEMENT_BONUS_HANDLER]).ICON_PATH
	var p1_movement = ui._players[1]._movement_ui
	var p2_movement = ui._players[2]._movement_ui
	assert_eq(p1_movement.DATA_ICON, p1_movement_icon_path)
	assert_eq(p2_movement.DATA_ICON, p2_movement_icon_path)
	assert_eq(p1_movement.QUANTITY, 3)
	assert_eq(p1_movement.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p1_movement.onready_paths.tokens), 3)
	assert_eq(p1_movement.onready_paths.overflow.text, "")
	assert_eq(p2_movement.QUANTITY, 3)
	assert_eq(p2_movement.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p2_movement.onready_paths.tokens), 3)
	assert_eq(p2_movement.onready_paths.overflow.text, "")
	ui.update_movement(1,1)
	await wait_process_frames(1)
	assert_eq(p1_movement.QUANTITY, 1)
	assert_eq(p1_movement.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p1_movement.onready_paths.tokens), 1)
	assert_eq(p1_movement.onready_paths.overflow.text, "")
	assert_eq(p2_movement.QUANTITY, 3)
	assert_eq(p2_movement.onready_paths.tokens.get_child_count(), 3)
	assert_eq(_count_visible_tokens(p2_movement.onready_paths.tokens), 3)
	assert_eq(p2_movement.onready_paths.overflow.text, "")

func test_splitter():
	# given
	var player_1_config = load(PLAYER_1_DEFAULT_CONFIG_PATH)
	var player_2_config = load(PLAYER_2_DEFAULT_CONFIG_PATH)
	player_1_config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	player_2_config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	# when / then
	var ui = scene.get_ui()
	ui.add_player(1,player_1_config,1)
	ui.add_player(2,player_2_config,3)
	await wait_process_frames(1)
	var p1_powerup_icon_path = load(PowerupDataUISettings.data[player_1_config.POWERUP_HANDLER]).ICON_PATH
	var p2_powerup_icon_path = load(PowerupDataUISettings.data[player_2_config.POWERUP_HANDLER]).ICON_PATH
	var p1_powerup = ui._players[1]._powerup_ui
	var p2_powerup = ui._players[2]._powerup_ui
	ui.update_powerup(1,1)
	ui.update_powerup(2,1)
	await wait_process_frames(1)
	assert_eq(p1_powerup.DATA_ICON, p1_powerup_icon_path)
	assert_eq(p2_powerup.DATA_ICON, p2_powerup_icon_path)
	assert_eq(p1_powerup.PROGRESS, 1)
	assert_eq(p1_powerup.onready_paths.overflow.text, "+1")
	assert_eq(p2_powerup.PROGRESS, 1)
	assert_eq(p2_powerup.onready_paths.overflow.text, "+1")
	ui.update_powerup(1,0.5)
	await wait_process_frames(1)
	assert_eq(p1_powerup.PROGRESS, 0.5)
	assert_eq(p1_powerup.onready_paths.overflow.text, "")
	assert_eq(p2_powerup.PROGRESS, 1)
	assert_eq(p2_powerup.onready_paths.overflow.text, "+1")
	


##### UTILS #####
func _count_visible_tokens(tokens_parent) -> int:
	var count = 0
	for token in tokens_parent.get_children():
		if token.visible:
			count += 1
	return count