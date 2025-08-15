extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var sprites

##### SETUP #####
func before_each():
	sprites = load("res://Scenes/Player/sprites.gd").new()

##### TEARDOWN #####
func after_each():
	sprites.free()

##### TESTS #####
func test_load_sprite_preset():
	# given
	var sprite_customization = SpriteCustomizationResource.new()
	sprite_customization.BODY_COLOR = Color.BLUE_VIOLET
	sprite_customization.OUTLINE_COLOR = Color.LAVENDER
	var body = Sprite2D.new()
	var outline = Sprite2D.new()
	sprites.onready_paths.body = body
	sprites.onready_paths.outline = outline
	# when
	sprites.load_sprite_preset(sprite_customization)
	# then
	assert_eq(sprites.onready_paths.body.modulate, Color.BLUE_VIOLET)
	assert_eq(sprites.onready_paths.outline.modulate, Color.LAVENDER)
	# cleanup
	body.free()
	outline.free()