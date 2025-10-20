extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var player_data

##### SETUP #####
func before_each():
	player_data = load("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.gd").new()

##### TEARDOWN #####
func after_each():
	player_data.free()

##### TESTS #####
func test_init():
	# given
	var mock_player_data = partial_double(load("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.gd")).new()
	stub(mock_player_data, "_clean").to_do_nothing()
	stub(mock_player_data, "_init_sprites").to_do_nothing()
	stub(mock_player_data, "_init_movement").to_do_nothing()
	stub(mock_player_data, "_add_h_separator").to_do_nothing()
	stub(mock_player_data, "_init_powerup").to_do_nothing()
	stub(mock_player_data, "_init_lives").to_do_nothing()
	stub(mock_player_data, "_init_name").to_do_nothing()
	var sprites = SpriteCustomizationResource.new()
	sprites.BODY_COLOR = Color.AZURE
	sprites.OUTLINE_COLOR = Color.AQUAMARINE
	# when
	mock_player_data.init(sprites,1,2,3)
	# then
	assert_called(mock_player_data, "_clean")
	assert_called(mock_player_data, "_init_sprites", [Color.AZURE, Color.AQUAMARINE])
	assert_called(mock_player_data, "_init_movement", [1])
	assert_called(mock_player_data, "_add_h_separator")
	assert_called(mock_player_data, "_init_powerup", [2])
	assert_called(mock_player_data, "_init_lives", [3])
	assert_called(mock_player_data, "_init_name", [player_data.TEMP_PLAYER_NAME])

func test_update_movement():
	# given
	var movement_ui = double(load("res://Scenes/UI/PlayersData/PlayerData/Templates/counter_block.gd")).new()
	stub(movement_ui, "set_value")
	player_data._movement_ui = movement_ui
	# when
	player_data.update_movement(2)
	# then
	assert_called(movement_ui, "set_value", [2])

func test_update_powerup():
	# given
	var powerup_ui = double(load("res://Scenes/UI/PlayersData/PlayerData/Templates/counter_block.gd")).new()
	stub(powerup_ui, "set_value")
	player_data._powerup_ui = powerup_ui
	# when
	player_data.update_powerup(2)
	# then
	assert_called(powerup_ui, "set_value", [2])

func test_update_lives():
	# given
	var lives_ui = double(load("res://Scenes/UI/PlayersData/PlayerData/Templates/counter_block.gd")).new()
	stub(lives_ui, "set_value")
	player_data._lives_ui = lives_ui
	# when
	player_data.update_lives(2)
	# then
	assert_called(lives_ui, "set_value", [2])

# _clean hard to test because it's mostly a queue_free thing

func test_add_h_separator():
	# given
	var important_data = Node2D.new()
	player_data.onready_paths.important_data = important_data
	add_child(important_data)
	wait_for_signal(important_data.tree_entered, 0.25)
	# when
	player_data._add_h_separator()
	# then
	assert_eq(important_data.get_child_count(), 1)
	# cleanup
	important_data.free()

func test_init_sprites():
	# given
	var body = Sprite2D.new()
	var outline = Sprite2D.new()
	player_data.onready_paths = {
		"sprites": {
			"body": body,
			"outline": outline
		}
	}
	# when
	player_data._init_sprites(Color.ALICE_BLUE, Color.AZURE)
	# then
	assert_eq(body.modulate, Color.ALICE_BLUE)
	assert_eq(outline.modulate, Color.AZURE)
	# cleanup
	body.free()
	outline.free()

func test_init_movement():
	# given
	var important_data = Node2D.new()
	add_child(important_data)
	wait_for_signal(important_data.tree_entered, 0.25)
	player_data.onready_paths.important_data = important_data
	# when
	player_data._init_movement(StaticMovementBonusHandler.handlers.DASH)
	# then
	assert_eq(important_data.get_child_count(), 1)
	assert_not_null(player_data._movement_ui)
	# cleanup
	important_data.free()

func test_init_powerup():
	# given
	var important_data = Node2D.new()
	add_child(important_data)
	wait_for_signal(important_data.tree_entered, 0.25)
	player_data.onready_paths.important_data = important_data
	# when
	player_data._init_powerup(StaticPowerupHandler.handlers.SPLITTER)
	# then
	assert_eq(important_data.get_child_count(), 1)
	assert_not_null(player_data._powerup_ui)
	# cleanup
	important_data.free()

func test_init_lives():
	# given
	var important_data = Node2D.new()
	add_child(important_data)
	wait_for_signal(important_data.tree_entered, 0.25)
	player_data.onready_paths.important_data = important_data
	# when
	player_data._init_lives(2)
	# then
	assert_eq(important_data.get_child_count(), 1)
	assert_not_null(player_data._lives_ui)
	# cleanup
	important_data.free()

func test_init_name():
	# given
	var l_name = Label.new()
	player_data.onready_paths.name = l_name
	# when
	player_data._init_name("test")
	# then
	assert_eq(l_name.text, "test")
	# cleanup
	l_name.free()

func test_on_movement_update_ui():
	# given
	var movement_ui = double(load("res://Scenes/UI/PlayersData/PlayerData/Templates/counter_block.gd")).new()
	stub(movement_ui, "set_value").to_do_nothing()
	player_data._movement_ui = movement_ui
	# when
	player_data._on_movement_update_ui(123)
	# then
	assert_called(movement_ui, "set_value", [123])

##### UTILS #####
func _something_useful():
	pass
