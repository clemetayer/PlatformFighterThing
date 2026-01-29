extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var preset

##### SETUP #####
func before_each():
	preset = load("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/preset.tscn").instantiate()
	add_child_autofree(preset)
	wait_for_signal(preset.tree_entered, 0.1)

##### TESTS #####
var ready_params := [
	[true],
	[false]
]
func test_ready(params = use_parameters(ready_params)):
	# given
	var small = params[0]
	preset.SMALL = small
	# when
	preset._ready()
	await wait_process_frames(3)
	# then
	assert_eq(preset.size.y, preset.HEIGHT_SMALL if small else preset.HEIGHT_BIG)

func test_set_preset():
	# given
	var config = PlayerConfig.new()
	config.PLAYER_NAME = "name"
	config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.handlers.REVOLVER
	config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	var sprite = SpriteCustomizationResource.new()
	sprite.BODY_COLOR = Color.ALICE_BLUE
	sprite.OUTLINE_COLOR = Color.REBECCA_PURPLE
	sprite.EYES_TEXTURE_PATH = "res://icon.svg"
	sprite.EYES_COLOR = Color.TAN
	sprite.MOUTH_TEXTURE_PATH = "res://icon.svg"
	sprite.MOUTH_COLOR = Color.YELLOW
	config.SPRITE_CUSTOMIZATION = sprite
	# when
	preset.set_preset(config)
	# then
	assert_eq(preset.onready_paths.name_label.text, "name")
	assert_not_null(preset.onready_paths.primary_weapon.texture)
	assert_not_null(preset.onready_paths.movement_bonus.texture)
	assert_not_null(preset.onready_paths.powerup.texture)
	assert_eq(preset.onready_paths.sprite.body.modulate, Color.ALICE_BLUE)
	assert_eq(preset.onready_paths.sprite.outline.modulate, Color.REBECCA_PURPLE)
	assert_not_null(preset.onready_paths.sprite.eyes.texture)
	assert_eq(preset.onready_paths.sprite.eyes.modulate, Color.TAN)
	assert_not_null(preset.onready_paths.sprite.mouth.texture)
	assert_eq(preset.onready_paths.sprite.mouth.modulate, Color.YELLOW)
