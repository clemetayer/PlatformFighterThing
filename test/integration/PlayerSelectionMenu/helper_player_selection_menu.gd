extends Node

##### VARIABLES #####
#---- CONSTANTS -----
const INTEGRATION_TEST_PRESET_PATH = "res://test/integration/PlayerSelectionMenu/integration_preset.tres"
const INTEGRATION_TEST_SAVE_PATH := StaticUtils.USER_CHARACTER_PRESETS_PATH + "integration_test" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
const INTEGRATION_TEST_PRESET_NAME := "integration_test"

#---- STANDARD -----
#==== PRIVATE ====
var _menu

##### PUBLIC METHODS #####
func set_selection_menu(menu):
	_menu = menu

func get_player_selection_items() -> Array:
	return _menu.onready_paths.player_selection_items.get_children()

func get_integration_test_config() -> PlayerConfig:
	return load(INTEGRATION_TEST_PRESET_PATH)

func save_std_preset() -> void:
	var preset = load(INTEGRATION_TEST_PRESET_PATH)
	ResourceSaver.save(preset, INTEGRATION_TEST_SAVE_PATH)

func remove_std_preset() -> void:
	remove_preset_with_name(INTEGRATION_TEST_PRESET_NAME)

func remove_preset_with_name(pname: String) -> void:
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(pname + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION)

func count_saved_presets() -> int:
	var dir = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	return dir.get_files().size()

func add_player_on_item(item: Node) -> void:
	item.onready_paths.add_player_button.emit_signal("pressed")

func is_add_player_visible(item: Node) -> bool:
	return item.onready_paths.add_player_button.visible

func is_main_menu_visible(item: Node) -> bool:
	return item.onready_paths.main_menu.visible

func remove_player_on_item(item: Node) -> void:
	item.onready_paths.main_menu.onready_paths.buttons.get_node("DeletePlayer").emit_signal("pressed")

func is_config_equals_display(config: PlayerConfig, item: Node) -> bool:
	var res = true
	var player_config_display = item.onready_paths.main_menu.onready_paths.sprite
	res = res and player_config_display.onready_paths.name.text == config.PLAYER_NAME
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.body.modulate == config.SPRITE_CUSTOMIZATION.BODY_COLOR
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.outline.modulate == config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.eyes.texture.resource_path == config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.eyes.modulate == config.SPRITE_CUSTOMIZATION.EYES_COLOR
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.mouth.texture.resource_path == config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH
	res = res and player_config_display.onready_paths.player_sprite.onready_paths.mouth.modulate == config.SPRITE_CUSTOMIZATION.MOUTH_COLOR
	res = res and player_config_display.onready_paths.weapons.primary.texture.resource_path == StaticPrimaryWeaponHandler.get_icon_path(config.PRIMARY_WEAPON)
	res = res and player_config_display.onready_paths.weapons.powerup.texture.resource_path == StaticPowerupHandler.get_icon_path(config.POWERUP_HANDLER)
	res = res and player_config_display.onready_paths.weapons.movement_bonus.texture.resource_path == StaticMovementBonusHandler.get_icon_path(config.MOVEMENT_BONUS_HANDLER)
	return res

func select_presets_menu(item: Node) -> void:
	item.onready_paths.main_menu.onready_paths.buttons.get_node("Preset").emit_signal("pressed")

func select_preset_config(config: PlayerConfig, item: Node) -> void:
	item._on_presets_preset_selected(config)

func get_presets(item: Node) -> Array:
	return item.onready_paths.presets_menu.onready_paths.presets_root.get_children()

func get_presets_configs(item: Node) -> Array:
	return item.onready_paths.presets_menu._presets

func is_preset_menu_visible(item: Node) -> bool:
	return item.onready_paths.presets_menu.visible

func is_preset_equal(preset: Button, config: PlayerConfig) -> bool:
	var res = true
	res = res and preset.onready_paths.name_label.text == config.PLAYER_NAME
	res = res and preset.onready_paths.primary_weapon.texture.resource_path == StaticPrimaryWeaponHandler.get_icon_path(config.PRIMARY_WEAPON)
	res = res and preset.onready_paths.movement_bonus.texture.resource_path == StaticMovementBonusHandler.get_icon_path(config.MOVEMENT_BONUS_HANDLER)
	res = res and preset.onready_paths.powerup.texture.resource_path == StaticPowerupHandler.get_icon_path(config.POWERUP_HANDLER)
	res = res and preset.onready_paths.primary_weapon.texture.resource_path == StaticPrimaryWeaponHandler.get_icon_path(config.PRIMARY_WEAPON)
	res = res and preset.onready_paths.sprite.body.modulate == config.SPRITE_CUSTOMIZATION.BODY_COLOR
	res = res and preset.onready_paths.sprite.outline.modulate == config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	res = res and preset.onready_paths.sprite.eyes.texture.resource_path == config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH
	res = res and preset.onready_paths.sprite.eyes.modulate == config.SPRITE_CUSTOMIZATION.EYES_COLOR
	res = res and preset.onready_paths.sprite.mouth.texture.resource_path == config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH
	res = res and preset.onready_paths.sprite.mouth.modulate == config.SPRITE_CUSTOMIZATION.MOUTH_COLOR
	return res

func preset_buttons_contains_preset(preset_buttons: Array, preset: PlayerConfig) -> bool:
	for preset_button in preset_buttons:
		if preset_button.name != "AddElementButton" and is_preset_equal(preset_button, preset):
			return true
	return false

func select_preset(preset: Button) -> void:
	preset.emit_signal("pressed")

func select_primary_weapon_menu(item: Node) -> void:
	item.onready_paths.main_menu.onready_paths.buttons.get_node("PrimaryWeapon").emit_signal("pressed")

func select_primary_weapon(idx: int, item: Node) -> void:
	item.onready_paths.primary_weapons_menu.onready_paths.items.select(idx)
	item.onready_paths.primary_weapons_menu.onready_paths.items.emit_signal("item_selected", idx)
	item.onready_paths.primary_weapons_menu.get_node("VBoxContainer/OkayButton").emit_signal("pressed")

func is_primary_weapon_menu_visible(item: Node) -> bool:
	return item.onready_paths.primary_weapons_menu.visible

func is_primary_weapon_selected(weapon: StaticPrimaryWeaponHandler.handlers, item: Node) -> bool:
	return item.get_config().PRIMARY_WEAPON == weapon

func select_movement_bonus_menu(item: Node) -> void:
	item.onready_paths.main_menu.onready_paths.buttons.get_node("MovementBonus").emit_signal("pressed")

func select_movement_bonus(idx: int, item: Node) -> void:
	item.onready_paths.movement_bonus_menu.onready_paths.items.select(idx)
	item.onready_paths.movement_bonus_menu.onready_paths.items.emit_signal("item_selected", idx)
	item.onready_paths.movement_bonus_menu.get_node("VBoxContainer/OkayButton").emit_signal("pressed")

func is_movement_bonus_menu_visible(item: Node) -> bool:
	return item.onready_paths.movement_bonus_menu.visible

func is_movement_bonus_selected(movement_bonus: StaticMovementBonusHandler.handlers, item: Node) -> bool:
	return item.get_config().MOVEMENT_BONUS_HANDLER == movement_bonus

func select_powerup_menu(item: Node) -> void:
	item.onready_paths.main_menu.onready_paths.buttons.get_node("Powerup").emit_signal("pressed")

func select_powerup(idx: int, item: Node) -> void:
	item.onready_paths.powerup_menu.onready_paths.items.select(idx)
	item.onready_paths.powerup_menu.onready_paths.items.emit_signal("item_selected", idx)
	item.onready_paths.powerup_menu.get_node("VBoxContainer/OkayButton").emit_signal("pressed")

func is_powerup_menu_visible(item: Node) -> bool:
	return item.onready_paths.powerup_menu.visible

func is_powerup_selected(powerup: StaticPowerupHandler.handlers, item: Node) -> bool:
	return item.get_config().POWERUP_HANDLER == powerup