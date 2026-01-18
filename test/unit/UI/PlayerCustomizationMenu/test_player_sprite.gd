extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var sprite

##### SETUP #####
func before_each():
	sprite = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.tscn").instantiate()
	add_child_autofree(sprite)
	wait_for_signal(sprite.tree_entered, 0.1)

##### TESTS #####
func test_update_sprite():
	# given
	var config = SpriteCustomizationResource.new()
	config.BODY_COLOR = Color.MAGENTA
	config.OUTLINE_COLOR = Color.KHAKI
	config.EYES_TEXTURE_PATH = "res://icon.svg"
	config.EYES_COLOR = Color.FIREBRICK
	config.MOUTH_TEXTURE_PATH = "res://icon.svg"
	config.MOUTH_COLOR = Color.GAINSBORO
	# when
	sprite.update_sprite(config)
	# then
	assert_eq(sprite.onready_paths.body.modulate, Color.MAGENTA)
	assert_eq(sprite.onready_paths.outline.modulate, Color.KHAKI)
	assert_not_null(sprite.onready_paths.eyes.texture)
	assert_eq(sprite.onready_paths.eyes.modulate, Color.FIREBRICK)
	assert_not_null(sprite.onready_paths.mouth.texture)
	assert_eq(sprite.onready_paths.mouth.modulate, Color.GAINSBORO)

# all the other functions already tested in update_sprite