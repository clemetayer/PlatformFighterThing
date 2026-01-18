extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var display

##### SETUP #####
func before_each():
	display = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.tscn").instantiate()
	add_child_autofree(display)
	await wait_for_signal(display.tree_entered, 0.1)

##### TESTS #####
func test_update_player():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_sprite").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	var player_config = PlayerConfig.new()
	player_config.PLAYER_NAME = "name"
	var sprite_customization = SpriteCustomizationResource.new()
	player_config.SPRITE_CUSTOMIZATION = sprite_customization
	player_config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.handlers.REVOLVER
	player_config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	player_config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	# when
	display.update_player(player_config)
	# then
	assert_called(player_sprite, "update_sprite")
	assert_eq(display.onready_paths.name.text, "name")
	assert_not_null(display.onready_paths.weapons.primary.texture)
	assert_not_null(display.onready_paths.weapons.powerup.texture)
	assert_not_null(display.onready_paths.weapons.movement_bonus.texture)

# update_primary_weapon, powerup, movement_bonu and name already tested in update_player

func test_update_body():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_body").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_body(Color.SADDLE_BROWN)
	# then
	assert_called(player_sprite, "update_body", [Color.SADDLE_BROWN])

func test_update_outline():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_outline").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_outline(Color.SADDLE_BROWN)
	# then
	assert_called(player_sprite, "update_outline", [Color.SADDLE_BROWN])

func test_update_eyes():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_eyes").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_eyes(load("res://icon.svg"))
	# then
	assert_called(player_sprite, "update_eyes")

func test_update_eyes_color():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_eyes_color").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_eyes_color(Color.SADDLE_BROWN)
	# then
	assert_called(player_sprite, "update_eyes_color", [Color.SADDLE_BROWN])

func test_update_mouth():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_mouth").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_mouth(load("res://icon.svg"))
	# then
	assert_called(player_sprite, "update_mouth")

func test_update_mouth_color():
	# given
	var player_sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(player_sprite, "update_mouth_color").to_do_nothing()
	display.onready_paths.player_sprite = player_sprite
	# when
	display.update_mouth_color(Color.SADDLE_BROWN)
	# then
	assert_called(player_sprite, "update_mouth_color", [Color.SADDLE_BROWN])