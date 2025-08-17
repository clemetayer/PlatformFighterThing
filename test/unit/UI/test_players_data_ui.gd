extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var pdui

##### SETUP #####
func before_each():
	pdui = load("res://Scenes/UI/PlayersData/players_data_ui.gd").new()

##### TEARDOWN #####
func after_each():
	pdui.free()

##### TESTS #####
func test_add_player():
	# given
	var config = PlayerConfig.new()
	var sprite_customization = SpriteCustomizationResource.new()
	sprite_customization.BODY_COLOR = Color.BEIGE
	sprite_customization.OUTLINE_COLOR = Color.GAINSBORO
	config.SPRITE_CUSTOMIZATION = sprite_customization
	config.ACTION_HANDLER = StaticActionHandlerStrategy.handlers.BASE
	config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.weapons.REVOLVER
	config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	config.ELIMINATION_TEXT = ""
	add_child(pdui)
	wait_for_signal(pdui.tree_entered, 0.25)
	# when
	pdui.add_player(1,config,2)
	# then
	assert_eq(pdui.get_child_count(), 1)
	assert_not_null(pdui._players[1])

func test_update_movement():
	# given
	var player_data = double(load("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.gd")).new()
	stub(player_data, "update_movement").to_do_nothing()
	pdui._players = {
		1: player_data
	}
	# when
	pdui.update_movement(1, 2)
	# then
	assert_called(player_data, "update_movement", [2])

func test_update_powerup():
	# given
	var player_data = double(load("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.gd")).new()
	stub(player_data, "update_powerup").to_do_nothing()
	pdui._players = {
		1: player_data
	}
	# when
	pdui.update_powerup(1, 2)
	# then
	assert_called(player_data, "update_powerup", [2])

func test_update_lives():
	# given
	var player_data = double(load("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.gd")).new()
	stub(player_data, "update_lives").to_do_nothing()
	pdui._players = {
		1: player_data
	}
	# when
	pdui.update_lives(1, 2)
	# then
	assert_called(player_data, "update_lives", [2])
