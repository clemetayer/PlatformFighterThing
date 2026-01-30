extends Node
# helper for the player customization menu

##### VARIABLES #####
#---- CONSTANTS -----
const INTEGRATION_TEST_PRESET_PATH := "res://test/integration/PlayerCustomizationMenu/integration_preset.tres"
const INTEGRATION_TEST_SAVE_PATH := StaticUtils.USER_CHARACTER_PRESETS_PATH + "integration_test" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
const INTEGRATION_TEST_PRESET_NAME := "integration_test"

#---- STANDARD -----
#==== PRIVATE ====
var _menu

##### PUBLIC METHODS #####
func count_saved_presets() -> int:
	var dir = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	return dir.get_files().size()

func set_customization_menu(menu):
	_menu = menu

func get_current_menu_config() -> PlayerConfig:
	return _menu._current_config

func get_integration_test_config() -> PlayerConfig:
	return load(INTEGRATION_TEST_PRESET_PATH)

func save_std_preset() -> void:
	var preset = load(INTEGRATION_TEST_PRESET_PATH)
	ResourceSaver.save(preset, INTEGRATION_TEST_SAVE_PATH)

func is_config_equals_display(config: PlayerConfig) -> bool:
	var res = true
	res = res and _menu.onready_paths.main_menu.onready_paths.name.text == config.PLAYER_NAME
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.body.modulate == config.SPRITE_CUSTOMIZATION.BODY_COLOR
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.outline.modulate == config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.eyes.texture.resource_path == config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.eyes.modulate == config.SPRITE_CUSTOMIZATION.EYES_COLOR
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.mouth.texture.resource_path == config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH
	res = res and _menu.onready_paths.main_menu.onready_paths.player_sprite.onready_paths.mouth.modulate == config.SPRITE_CUSTOMIZATION.MOUTH_COLOR
	res = res and _menu.onready_paths.main_menu.onready_paths.weapons.primary.texture.resource_path == StaticPrimaryWeaponHandler.get_icon_path(config.PRIMARY_WEAPON)
	res = res and _menu.onready_paths.main_menu.onready_paths.weapons.powerup.texture.resource_path == StaticPowerupHandler.get_icon_path(config.POWERUP_HANDLER)
	res = res and _menu.onready_paths.main_menu.onready_paths.weapons.movement_bonus.texture.resource_path == StaticMovementBonusHandler.get_icon_path(config.MOVEMENT_BONUS_HANDLER)
	return res

func update_config(config: PlayerConfig) -> void:
	_menu._on_presets_preset_selected(config)

func remove_std_preset() -> void:
	remove_preset_with_name(INTEGRATION_TEST_PRESET_NAME)

func remove_preset_with_name(pname: String) -> void:
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(pname + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION)

func open_presets_tab() -> void:
	_menu.get_node("MarginContainer/MenuRoot/TabContainer/Presets").visible = true

func is_preset_tab_visible() -> bool:
	return _menu.get_node("MarginContainer/MenuRoot/TabContainer/Presets").visible

func get_presets() -> Array:
	return _menu.get_node("MarginContainer/MenuRoot/TabContainer/Presets").onready_paths.presets_root.get_children()

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

func open_primary_weapon_tab() -> void:
	_menu.onready_paths.primary_weapons_menu.visible = true

func is_primary_weapon_tab_visible() -> bool:
	return _menu.onready_paths.primary_weapons_menu.visible

func select_primary_weapon(idx: int) -> void:
	_menu.onready_paths.primary_weapons_menu.onready_paths.items.select(idx)
	_menu.onready_paths.primary_weapons_menu.onready_paths.items.emit_signal("item_selected", idx)

func is_primary_weapon_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.primary_weapons_menu.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.primary_weapons_menu.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.primary_weapons_menu.onready_paths.description.description.text == element.DESCRIPTION
	return res

func open_movement_bonus_tab() -> void:
	_menu.onready_paths.movement_bonus_menu.visible = true

func is_movement_bonus_tab_visible() -> bool:
	return _menu.onready_paths.movement_bonus_menu.visible

func select_movement_bonus(idx: int) -> void:
	_menu.onready_paths.movement_bonus_menu.onready_paths.items.select(idx)
	_menu.onready_paths.movement_bonus_menu.onready_paths.items.emit_signal("item_selected", idx)

func is_movement_bonus_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.movement_bonus_menu.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.movement_bonus_menu.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.movement_bonus_menu.onready_paths.description.description.text == element.DESCRIPTION
	return res

func open_powerup_tab() -> void:
	_menu.onready_paths.powerup_menu.visible = true

func is_powerup_tab_visible() -> bool:
	return _menu.onready_paths.powerup_menu.visible

func select_powerup(idx: int) -> void:
	_menu.onready_paths.powerup_menu.onready_paths.items.select(idx)
	_menu.onready_paths.powerup_menu.onready_paths.items.emit_signal("item_selected", idx)

func is_powerup_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.powerup_menu.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.powerup_menu.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.powerup_menu.onready_paths.description.description.text == element.DESCRIPTION
	return res

func press_ready() -> void:
	_menu.get_node("MarginContainer/MenuRoot/ReadyButton").emit_signal("pressed")

func is_menu_visible() -> bool:
	return _menu.onready_paths.menu_root.visible

func is_waiting_text_visible() -> bool:
	return _menu.onready_paths.waiting_players_label.visible