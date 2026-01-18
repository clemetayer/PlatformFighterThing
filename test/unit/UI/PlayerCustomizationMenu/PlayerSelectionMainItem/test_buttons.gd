extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var buttons

##### SETUP #####
func before_each():
	buttons = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/buttons.gd").new()

##### TEARDOWN #####
func after_each():
	buttons.free()

##### TESTS #####
func test_set_primary_weapon_icon():
	# given
	var primary_weapon = Button.new()
	buttons.onready_paths.primary_weapon = primary_weapon
	# when
	buttons.set_primary_weapon_icon(StaticPrimaryWeaponHandler.handlers.REVOLVER)
	# then
	assert_not_null(buttons.onready_paths.primary_weapon.icon)
	# cleanup
	primary_weapon.free()

func test_set_movement_bonus_icon():
	# given
	var movement_bonus = Button.new()
	buttons.onready_paths.movement_bonus = movement_bonus
	# when
	buttons.set_movement_bonus_icon(StaticMovementBonusHandler.handlers.DASH)
	# then
	assert_not_null(buttons.onready_paths.movement_bonus.icon)
	# cleanup
	movement_bonus.free()

func test_set_powerup_icon():
	# given
	var powerup = Button.new()
	buttons.onready_paths.powerup = powerup
	# when
	buttons.set_powerup_icon(StaticPowerupHandler.handlers.SPLITTER)
	# then
	assert_not_null(buttons.onready_paths.powerup.icon)
	# cleanup
	powerup.free()

func test_reset_player_type():
	# given
	var player_type = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/player_type_button.gd")).new()
	stub(player_type, "reset").to_do_nothing()
	buttons.onready_paths.player_type = player_type
	# when
	buttons.reset_player_type()
	# then
	assert_called(player_type, "reset")
