extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var item
var player_added_times_called := 0

##### SETUP #####
func before_each():
	item = load("res://Scenes/UI/PlayerCustomizationMenu/player_selection_item.tscn").instantiate()
	add_child_autofree(item)
	await wait_for_signal(item.tree_entered, 0.1)
	player_added_times_called = 0

##### TESTS #####
# _ready hard to test with the mock replacement

func test_get_config():
	# given
	var config = PlayerConfig.new()
	item._current_config = config
	# when
	var res = item.get_config()
	# then
	assert_eq(res, config)

func test_init_default_config():
	# given
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_player_config").to_do_nothing()
	# when
	item._init_default_config()
	# then
	assert_not_null(item._current_config)
	assert_called(main_menu, "update_player_config")

func test_init_primary_weapon_items():
	# given
	var primary_weapon = create_primary_weapon_mock()
	stub(primary_weapon, "set_items").to_do_nothing()
	# when
	item._init_primary_weapon_items()
	# then
	assert_called(primary_weapon, "set_items")

func test_init_movement_bonus_items():
	# given
	var movement_bonus = create_movement_bonus_mock()
	stub(movement_bonus, "set_items").to_do_nothing()
	# when
	item._init_movement_bonus_items()
	# then
	assert_called(movement_bonus, "set_items")

func test_init_powerup_items():
	# given
	var powerup = create_powerup_mock()
	stub(powerup, "set_items").to_do_nothing()
	# when
	item._init_powerup_items()
	# then
	assert_called(powerup, "set_items")

func test_on_add_player_pressed():
	# given
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_player_config").to_do_nothing()
	item.connect("player_added", _on_player_added)
	# when
	item._on_add_player_pressed()
	# then
	assert_called(main_menu, "update_player_config")
	assert_eq(player_added_times_called, 1)
	assert_false(item.onready_paths.add_player_button.visible)

func test_on_main_delete_item():
	# given
	# when
	item._on_main_delete_item()
	# then
	assert_null(item._current_config)
	assert_false(item.onready_paths.main_menu.visible)
	assert_true(item.onready_paths.add_player_button.visible)

func test_on_main_open_movement_bonus_menu_triggered():
	# given
	# when
	item._on_main_open_movement_bonus_menu_triggered()
	# then
	assert_false(item.onready_paths.main_menu.visible)
	assert_true(item.onready_paths.movement_bonus_menu.visible)

func test_on_main_open_powerup_menu_triggered():
	# given
	# when
	item._on_main_open_powerup_menu_triggered()
	# then
	assert_false(item.onready_paths.main_menu.visible)
	assert_true(item.onready_paths.powerup_menu.visible)

func test_on_main_open_preset_menu_triggered():
	# given
	# when
	item._on_main_open_preset_menu_triggered()
	# then
	assert_false(item.onready_paths.main_menu.visible)
	assert_true(item.onready_paths.presets_menu.visible)

func test_on_main_open_primary_weapon_menu_triggered():
	# given
	# when
	item._on_main_open_primary_weapon_menu_triggered()
	# then
	assert_false(item.onready_paths.main_menu.visible)
	assert_true(item.onready_paths.primary_weapons_menu.visible)
	
func test_on_presets_close_triggered():
	# given
	# when
	item._on_presets_close_triggered()
	# then
	assert_true(item.onready_paths.main_menu.visible)
	assert_false(item.onready_paths.presets_menu.visible)

func test_on_primary_weapons_grid_close_triggered():
	# given
	# when
	item._on_primary_weapons_grid_close_triggered()
	# then
	assert_true(item.onready_paths.main_menu.visible)
	assert_false(item.onready_paths.primary_weapons_menu.visible)

func test_on_movement_bonus_grid_close_triggered():
	# given
	# when
	item._on_movement_bonus_grid_close_triggered()
	# then
	assert_true(item.onready_paths.main_menu.visible)
	assert_false(item.onready_paths.movement_bonus_menu.visible)

func test_on_powerups_grid_close_triggered():
	# given
	# when
	item._on_powerup_grid_close_triggered()
	# then
	assert_true(item.onready_paths.main_menu.visible)
	assert_false(item.onready_paths.powerup_menu.visible)

func test_on_primary_weapons_grid_item_selected():
	# given
	var config = PlayerConfig.new()
	item._current_config = config
	var item_element = ItemGridMenuElement.new()
	item_element.ITEM_ID = 0
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_primary_weapon").to_do_nothing()
	# when
	item._on_primary_weapons_grid_item_selected(item_element)
	# then
	assert_called(main_menu, "update_primary_weapon", [0])
	assert_eq(config.PRIMARY_WEAPON, 0)
	assert_false(item.onready_paths.primary_weapons_menu.visible)

func test_on_movement_bonus_grid_item_selected():
	# given
	var config = PlayerConfig.new()
	item._current_config = config
	var item_element = ItemGridMenuElement.new()
	item_element.ITEM_ID = 0
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_movement_bonus").to_do_nothing()
	# when
	item._on_movement_bonus_grid_item_selected(item_element)
	# then
	assert_called(main_menu, "update_movement_bonus", [0])
	assert_eq(config.MOVEMENT_BONUS_HANDLER, 0)
	assert_false(item.onready_paths.movement_bonus_menu.visible)

func test_on_powerup_grid_item_selected():
	# given
	var config = PlayerConfig.new()
	item._current_config = config
	var item_element = ItemGridMenuElement.new()
	item_element.ITEM_ID = 0
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_powerup").to_do_nothing()
	# when
	item._on_powerup_grid_item_selected(item_element)
	# then
	assert_called(main_menu, "update_powerup", [0])
	assert_eq(config.POWERUP_HANDLER, 0)
	assert_false(item.onready_paths.powerup_menu.visible)

func test_on_presets_preset_selected():
	# given
	var config = PlayerConfig.new()
	var main_menu = create_main_menu_mock()
	stub(main_menu, "update_player_config").to_do_nothing()
	# when
	item._on_presets_preset_selected(config)
	# then
	assert_called(main_menu, "update_player_config", [config])
	assert_eq(item._current_config, config)
	assert_false(item.onready_paths.powerup_menu.visible)

func test_on_main_player_type_changed():
	# given
	var config = PlayerConfig.new()
	item._current_config = config
	var handler = StaticActionHandler.handlers.INPUT
	# when
	item._on_main_player_type_changed(handler)
	# then
	assert_eq(config.ACTION_HANDLER, handler)

##### UTILS #####
func _on_player_added() -> void:
	player_added_times_called += 1

func create_main_menu_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/player_selection_main_item.gd")).new()
	item.onready_paths.main_menu = mock
	return mock

func create_primary_weapon_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	item.onready_paths.primary_weapons_menu = mock
	return mock

func create_movement_bonus_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	item.onready_paths.movement_bonus_menu = mock
	return mock

func create_powerup_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	item.onready_paths.powerup_menu = mock
	return mock
