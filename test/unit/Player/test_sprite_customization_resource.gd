extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var sprite_customization_resource

##### SETUP #####
func before_each():
	sprite_customization_resource = SpriteCustomizationResource.new()

##### TESTS #####
func test_serialize():
	# given
	sprite_customization_resource.BODY_COLOR = Color.TAN
	sprite_customization_resource.OUTLINE_COLOR = Color.INDIGO
	sprite_customization_resource.EYES_TEXTURE_PATH = "res://Scenes/Player/Eyes/eyes_1.PNG"
	sprite_customization_resource.EYES_COLOR = Color.RED
	sprite_customization_resource.MOUTH_TEXTURE_PATH = "res://Scenes/Player/Mouths/mouth_1.PNG"
	sprite_customization_resource.MOUTH_COLOR = Color.FIREBRICK
	var expected_result = {
		"body_color": Color.TAN.to_html(),
		"outline_color": Color.INDIGO.to_html(),
		"eyes_texture_path": "res://Scenes/Player/Eyes/eyes_1.PNG",
		"eyes_color": Color.RED.to_html(),
		"mouth_texture_path": "res://Scenes/Player/Mouths/mouth_1.PNG",
		"mouth_color": Color.FIREBRICK.to_html(),
	}
	# when
	var res = sprite_customization_resource.serialize()
	# then
	assert_eq(res, expected_result)

func test_deserialize():
	# given
	var data = {
		"body_color": Color.TAN.to_html(),
		"outline_color": Color.INDIGO.to_html(),
		"eyes_texture_path": "res://Scenes/Player/Eyes/eyes_1.PNG",
		"eyes_color": Color.RED.to_html(),
		"mouth_texture_path": "res://Scenes/Player/Mouths/mouth_1.PNG",
		"mouth_color": Color.FIREBRICK.to_html(),
	}
	# when
	sprite_customization_resource.deserialize(data)
	# then
	assert_eq(sprite_customization_resource.BODY_COLOR, Color.TAN)
	assert_eq(sprite_customization_resource.OUTLINE_COLOR, Color.INDIGO)
	assert_eq(sprite_customization_resource.EYES_TEXTURE_PATH, "res://Scenes/Player/Eyes/eyes_1.PNG")
	assert_eq(sprite_customization_resource.EYES_COLOR, Color.RED)
	assert_eq(sprite_customization_resource.MOUTH_TEXTURE_PATH, "res://Scenes/Player/Mouths/mouth_1.PNG")
	assert_eq(sprite_customization_resource.MOUTH_COLOR, Color.FIREBRICK)