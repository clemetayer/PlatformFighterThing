extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var player_ready_times_called := 0
var player_ready_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/online_player_selection_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)
	player_ready_times_called = 0
	player_ready_args = []

##### TESTS #####
# _ready tough to test because calling it resets the mocks

func test_init_default_config():
	# given
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_player").to_do_nothing()
	# when
	menu._init_default_config()
	# then
	assert_called(main_menu, "update_player")

func test_init_primary_weapon_items():
	# given
	var primary_weapon = create_primary_weapon_mock()
	stub(primary_weapon, "set_items").to_do_nothing()
	# when
	menu._init_primary_weapon_items()
	# then
	assert_called(primary_weapon, "set_items")

func test_init_movement_bonus_items():
	# given
	var movement_bonus = create_movement_bonus_mock()
	stub(movement_bonus, "set_items").to_do_nothing()
	# when
	menu._init_movement_bonus_items()
	# then
	assert_called(movement_bonus, "set_items")

func test_init_powerup_items():
	# given
	var powerup = create_powerup_mock()
	stub(powerup, "set_items").to_do_nothing()
	# when
	menu._init_powerup_items()
	# then
	assert_called(powerup, "set_items")

func test_on_ready_button_pressed():
	# given
	menu.connect("player_ready", _on_player_ready)
	var config = PlayerConfig.new()
	menu._current_config = config
	# when
	menu._on_ready_button_pressed()
	# then
	assert_false(menu.onready_paths.menu_root.visible)
	assert_true(menu.onready_paths.waiting_players_label.visible)
	assert_eq(player_ready_times_called, 1)
	assert_eq(player_ready_args, [[config]])

func test_on_presets_preset_selected():
	# given
	var config = PlayerConfig.new()
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_player").to_do_nothing()
	# when
	menu._on_presets_preset_selected(config)
	# then
	assert_eq(menu._current_config, config)
	assert_called(main_menu, "update_player", [config])

func test_on_primary_weapon_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	var expected_id = StaticPrimaryWeaponHandler.handlers.REVOLVER
	item.ITEM_ID = expected_id
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_primary_weapon").to_do_nothing()
	# when
	menu._on_primary_weapon_item_selected(item)
	# then
	menu._current_config.PRIMARY_WEAPON = expected_id
	assert_called(main_menu, "update_primary_weapon", [expected_id])

func test_on_movement_bonus_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	var expected_id = StaticMovementBonusHandler.handlers.DASH
	item.ITEM_ID = expected_id
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_movement_bonus").to_do_nothing()
	# when
	menu._on_movement_bonus_item_selected(item)
	# then
	menu._current_config.MOVEMENT_BONUS_HANDLER = expected_id
	assert_called(main_menu, "update_movement_bonus", [expected_id])

func test_on_powerup_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	var expected_id = StaticPowerupHandler.handlers.SPLITTER
	item.ITEM_ID = expected_id
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_powerup").to_do_nothing()
	# when
	menu._on_powerup_item_selected(item)
	# then
	menu._current_config.POWERUP_HANDLER = expected_id
	assert_called(main_menu, "update_powerup", [expected_id])

##### UTILS #####
func create_main_menu_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	menu.onready_paths.main_menu = mock
	return mock

func create_primary_weapon_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.primary_weapons_menu = mock
	return mock

func create_movement_bonus_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.movement_bonus_menu = mock
	return mock

func create_powerup_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.powerup_menu = mock
	return mock

func _on_player_ready(player_ready: PlayerConfig) -> void:
	player_ready_times_called += 1
	player_ready_args.append([player_ready])