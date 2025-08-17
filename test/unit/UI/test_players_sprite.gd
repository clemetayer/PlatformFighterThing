extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var players_sprite

##### SETUP #####
func before_each():
	players_sprite = load("res://Scenes/UI/PlayersData/PlayerData/players_sprite.gd").new()

##### TEARDOWN #####
func after_each():
	players_sprite.free()

##### TESTS #####
func test_set_sprites():
	# given
	var sprites_data = SpriteCustomizationResource.new()
	sprites_data.BODY_COLOR = Color.AQUAMARINE
	sprites_data.OUTLINE_COLOR = Color.BROWN
	var body = Sprite2D.new()
	var outline = Sprite2D.new()
	players_sprite.onready_paths.body = body
	players_sprite.onready_paths.outline = outline
	# when
	players_sprite.set_sprites(sprites_data)
	# then
	assert_eq(body.modulate, Color.AQUAMARINE)
	assert_eq(outline.modulate, Color.BROWN)
	# cleanup
	body.free()
	outline.free()

