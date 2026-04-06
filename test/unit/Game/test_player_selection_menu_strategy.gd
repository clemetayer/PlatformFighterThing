extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var players_ready_times_called := 0
var players_ready_args := []


##### SETUP #####
func before_each():
	menu = load("res://Scenes/GameManagers/player_selection_menu_strategy.gd").new()
	players_ready_times_called = 0
	players_ready_args = []


##### TEARDOWN #####
func after_each():
	menu.free()

##### TESTS #####
# reset mostly queue_free and not interacting well with gdunit


func test_init():
	# given
	# when
	menu.init()
	# then
	assert_eq(menu.get_child_count(), 1)
	var child_menu = menu.get_children()[0]
	assert_not_null(child_menu)
	assert_eq(child_menu.name, "PlayerSelectionMenu")
	assert_true(child_menu.is_connected("players_ready", menu._on_players_ready))
	# cleanup
	child_menu.free()


func test_players_ready():
	# given
	menu.init()
	var child_menu = menu.get_children()[0]
	menu.players_ready.connect(_on_players_ready)
	var player_1 = PlayerConfig.new()
	var sprite = SpriteCustomizationResource.new()
	player_1.SPRITE_CUSTOMIZATION = sprite
	var player_2 = PlayerConfig.new()
	player_2.SPRITE_CUSTOMIZATION = sprite
	# when
	child_menu.players_ready.emit([player_1, player_2])
	# then
	assert_eq(players_ready_times_called, 1)
	assert_eq(players_ready_args, [[{ 0: player_1, 1: player_2 }]])
	# cleanup
	child_menu.free()


##### UTILS  #####
func _on_players_ready(players_config: Dictionary) -> void:
	players_ready_times_called += 1
	players_ready_args.append([players_config])
