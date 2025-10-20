extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var player_config_node

##### SETUP #####
func before_each():
	player_config_node = load("res://Scenes/Player/player_config_node.gd").new()

##### TEARDOWN #####
func after_each():
	player_config_node.free()

##### TESTS #####
func test_ready():
	# given
	var config = PlayerConfig.new()
	config.ACTION_HANDLER = StaticActionHandler.handlers.RECORD
	config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.handlers.REVOLVER
	config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	var sprite_customization = SpriteCustomizationResource.new()
	sprite_customization.BODY_COLOR = Color.AZURE
	sprite_customization.OUTLINE_COLOR = Color.BEIGE
	config.SPRITE_CUSTOMIZATION = sprite_customization
	player_config_node.CONFIG = config
	# when
	add_child(player_config_node)
	wait_for_signal(player_config_node.tree_entered, 0.25)
	# then
	assert_eq(player_config_node.ACTION_HANDLER, config.ACTION_HANDLER)
	assert_eq(player_config_node.PRIMARY_WEAPON, config.PRIMARY_WEAPON)
	assert_eq(player_config_node.MOVEMENT_BONUS_HANDLER, config.MOVEMENT_BONUS_HANDLER)
	assert_eq(player_config_node.POWERUP_HANDLER, config.POWERUP_HANDLER)
	assert_eq(player_config_node.SPRITE_CUSTOMIZATION, config.SPRITE_CUSTOMIZATION)

