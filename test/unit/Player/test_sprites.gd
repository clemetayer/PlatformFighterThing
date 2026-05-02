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


var aim_params := [
	[-1 * Vector2.ONE],
	[Vector2.ONE],
]


func test_aim(params = use_parameters(aim_params)):
	# given
	var relative_aim_position = params[0]
	var rotate_elements = Node2D.new()
	sprites.onready_paths.rotate_elements = rotate_elements
	# when
	sprites.aim(relative_aim_position)
	# then
	if relative_aim_position.x < 0:
		assert_almost_eq(rotate_elements.rotation, -3 * PI / 4.0, 0.001)
		assert_eq(rotate_elements.scale.y, -1)
	else:
		assert_almost_eq(rotate_elements.rotation, PI / 4.0, 0.001)
		assert_eq(rotate_elements.scale.y, 1)
	# cleanup
	rotate_elements.free()


func test_set_player_indicator():
	# given
	var player_indicator = double(load("res://Scenes/Player/player_indicator_outline.gd")).new()
	stub(player_indicator, "set_player_color").to_do_nothing()
	sprites.onready_paths.player_indicator_outline = player_indicator
	# when
	sprites.set_player_indicator(1)
	# then
	assert_called(player_indicator, "set_player_color", [1])

