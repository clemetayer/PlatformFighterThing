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
	sprite_customization.EYES_COLOR = Color.DARK_GOLDENROD
	sprite_customization.MOUTH_COLOR = Color.HONEYDEW
	sprite_customization.EYES_TEXTURE_PATH = "res://Scenes/Player/Eyes/eyes_1.PNG"
	sprite_customization.MOUTH_TEXTURE_PATH = "res://Scenes/Player/Mouths/mouth_1.PNG"
	var body = Sprite2D.new()
	var outline = Sprite2D.new()
	var eyes = Sprite2D.new()
	var mouth = Sprite2D.new()
	sprites.onready_paths.body = body
	sprites.onready_paths.outline = outline
	sprites.onready_paths.eyes = eyes
	sprites.onready_paths.mouth = mouth
	# when
	sprites.load_sprite_preset(sprite_customization)
	# then
	assert_eq(sprites.onready_paths.body.modulate, Color.BLUE_VIOLET)
	assert_eq(sprites.onready_paths.outline.modulate, Color.LAVENDER)
	assert_eq(sprites.onready_paths.eyes.modulate, Color.DARK_GOLDENROD)
	assert_eq(sprites.onready_paths.mouth.modulate, Color.HONEYDEW)
	assert_not_null(sprites.onready_paths.eyes.texture)
	assert_not_null(sprites.onready_paths.mouth.texture)
	# cleanup
	body.free()
	outline.free()
	eyes.free()
	mouth.free()