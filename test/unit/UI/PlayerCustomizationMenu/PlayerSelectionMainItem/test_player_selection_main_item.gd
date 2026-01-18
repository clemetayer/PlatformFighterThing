extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var main_item
var open_preset_menu_triggered_times_called := 0
var open_primary_weapon_menu_triggered_times_called := 0
var open_movement_bonus_menu_triggered_times_called := 0
var open_powerup_menu_triggered_times_called := 0
var delete_item_times_called := 0
var player_type_changed_times_called := 0
var player_type_changed_args := []

##### SETUP #####
func before_each():
	main_item = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/player_selection_main_item.tscn").instantiate()
	add_child_autofree(main_item)
	await wait_for_signal(main_item.tree_entered, 0.1)
	delete_item_times_called = 0
	open_powerup_menu_triggered_times_called = 0
	open_movement_bonus_menu_triggered_times_called = 0
	open_primary_weapon_menu_triggered_times_called = 0
	open_preset_menu_triggered_times_called = 0
	player_type_changed_times_called = 0
	player_type_changed_args = []

##### TESTS #####
func test_update_configs():
	# given
	var sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	stub(sprite, "update_player").to_do_nothing()
	main_item.onready_paths.sprite = sprite
	var buttons = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/buttons.gd")).new()
	stub(buttons, "set_primary_weapon_icon").to_do_nothing()
	stub(buttons, "set_movement_bonus_icon").to_do_nothing()
	stub(buttons, "set_powerup_icon").to_do_nothing()
	stub(buttons, "reset_player_type").to_do_nothing()
	main_item.onready_paths.buttons = buttons
	var config = PlayerConfig.new()
	config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.handlers.REVOLVER
	config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	# when
	main_item.update_player_config(config)
	# then
	assert_called(sprite, "update_player", [config])
	assert_called(buttons, "set_primary_weapon_icon", [StaticPrimaryWeaponHandler.handlers.REVOLVER])
	assert_called(buttons, "set_movement_bonus_icon", [StaticMovementBonusHandler.handlers.DASH])
	assert_called(buttons, "set_powerup_icon", [StaticPowerupHandler.handlers.SPLITTER])
	assert_called(buttons, "reset_player_type")

func test_update_primary_weapon():
	# given
	var sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	stub(sprite, "update_primary_weapon").to_do_nothing()
	main_item.onready_paths.sprite = sprite
	var buttons = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/buttons.gd")).new()
	stub(buttons, "set_primary_weapon_icon").to_do_nothing()
	main_item.onready_paths.buttons = buttons
	var handler = StaticPrimaryWeaponHandler.handlers.REVOLVER
	# when
	main_item.update_primary_weapon(handler)
	# then
	assert_called(sprite, "update_primary_weapon", [handler])
	assert_called(buttons, "set_primary_weapon_icon", [handler])

func test_update_movement_bonus():
	# given
	var sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	stub(sprite, "update_movement_bonus").to_do_nothing()
	main_item.onready_paths.sprite = sprite
	var buttons = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/buttons.gd")).new()
	stub(buttons, "set_movement_bonus_icon").to_do_nothing()
	main_item.onready_paths.buttons = buttons
	var handler = StaticMovementBonusHandler.handlers.DASH
	# when
	main_item.update_movement_bonus(handler)
	# then
	assert_called(sprite, "update_movement_bonus", [handler])
	assert_called(buttons, "set_movement_bonus_icon", [handler])

func test_update_powerup():
	# given
	var sprite = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	stub(sprite, "update_powerup").to_do_nothing()
	main_item.onready_paths.sprite = sprite
	var buttons = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSelectionMainItem/buttons.gd")).new()
	stub(buttons, "set_powerup_icon").to_do_nothing()
	main_item.onready_paths.buttons = buttons
	var handler = StaticPowerupHandler.handlers.SPLITTER
	# when
	main_item.update_powerup(handler)
	# then
	assert_called(sprite, "update_powerup", [handler])
	assert_called(buttons, "set_powerup_icon", [handler])

func test_on_preset_pressed():
	# given
	main_item.connect("open_preset_menu_triggered", _on_open_preset_menu_triggered)
	# when
	main_item._on_preset_pressed()
	# then
	assert_eq(open_preset_menu_triggered_times_called, 1)

func test_on_primary_weapon_pressed():
	# given
	main_item.connect("open_primary_weapon_menu_triggered", _on_open_primary_weapon_menu_triggered)
	# when
	main_item._on_primary_weapon_pressed()
	# then
	assert_eq(open_primary_weapon_menu_triggered_times_called, 1)

func test_on_movement_bonus_pressed():
	# given
	main_item.connect("open_movement_bonus_menu_triggered", _on_open_movement_bonus_menu_triggered)
	# when
	main_item._on_movement_bonus_pressed()
	# then
	assert_eq(open_movement_bonus_menu_triggered_times_called, 1)

func test_on_powerup_pressed():
	# given
	main_item.connect("open_powerup_menu_triggered", _on_open_powerup_menu_triggered)
	# when
	main_item._on_powerup_pressed()
	# then
	assert_eq(open_powerup_menu_triggered_times_called, 1)

func test_on_delete_player_pressed():
	# given
	main_item.connect("delete_item", _on_delete_item)
	# when
	main_item._on_delete_player_pressed()
	# then
	assert_eq(delete_item_times_called, 1)

func test_on_player_type_changed_pressed():
	# given
	main_item.connect("player_type_changed", _on_player_type_changed)
	# when
	main_item._on_player_type_player_type_changed(StaticActionHandler.handlers.INPUT)
	# then
	assert_eq(player_type_changed_times_called, 1)
	assert_eq(player_type_changed_args, [[StaticActionHandler.handlers.INPUT]])


##### UTILS #####
func _on_player_type_changed(player_type: StaticActionHandler.handlers) -> void:
	player_type_changed_times_called += 1
	player_type_changed_args.append([player_type])

func _on_delete_item() -> void:
	delete_item_times_called += 1
 
func _on_open_powerup_menu_triggered() -> void:
	open_powerup_menu_triggered_times_called += 1

func _on_open_movement_bonus_menu_triggered() -> void:
	open_movement_bonus_menu_triggered_times_called += 1

func _on_open_primary_weapon_menu_triggered() -> void:
	open_primary_weapon_menu_triggered_times_called += 1

func _on_open_preset_menu_triggered() -> void:
	open_preset_menu_triggered_times_called += 1