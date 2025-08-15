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
	var expected_result = {
		"body_color": Color.TAN.to_html(),
		"outline_color": Color.INDIGO.to_html()
	}
	# when
	var res = sprite_customization_resource.serialize()
	# then
	assert_eq(res, expected_result)

func test_deserialize():
	# given
	var data = {
		"body_color": Color.TAN.to_html(),
		"outline_color": Color.INDIGO.to_html()
	}
	# when
	sprite_customization_resource.deserialize(data)
	# then
	assert_eq(sprite_customization_resource.BODY_COLOR, Color.TAN)
	assert_eq(sprite_customization_resource.OUTLINE_COLOR, Color.INDIGO)