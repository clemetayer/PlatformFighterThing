extends Node
# helper for the player customization menu

##### VARIABLES #####
#---- CONSTANTS -----
const INTEGRATION_TEST_PRESET_PATH := "res://test/integration/PlayerCustomizationMenu/integration_preset.tres"
const INTEGRATION_TEST_SAVE_PATH := StaticUtils.USER_CHARACTER_PRESETS_PATH + "integration_test" + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION
const INTEGRATION_TEST_PRESET_NAME := "integration_test"
const INTEGRATION_TEST_2_PRESET_NAME := "integration_test_2"
const NAME_LIST_RESOURCE_FILE := "user://names.tres"
const INTEGRATION_TEST_NAME := "integration_test"
const INTEGRATION_TEST_NAME_2 := "integration_test_2"

#---- STANDARD -----
#==== PRIVATE ====
var _menu

##### PUBLIC METHODS #####
func count_saved_presets() -> int:
	var dir = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	return dir.get_files().size()

func count_saved_names() -> int:
	if not ResourceLoader.exists(NAME_LIST_RESOURCE_FILE):
		return 0
	return load(NAME_LIST_RESOURCE_FILE).NAME_LIST.size()

func set_customization_menu(menu):
	_menu = menu

func get_current_menu_config() -> PlayerConfig:
	return _menu._current_config

func get_integration_test_config() -> PlayerConfig:
	return load(INTEGRATION_TEST_PRESET_PATH)

func save_std_preset() -> void:
	var preset = load(INTEGRATION_TEST_PRESET_PATH)
	ResourceSaver.save(preset, INTEGRATION_TEST_SAVE_PATH)

func add_name_in_name_resource(pname: String) -> void:
	var _name_list: NameListResource
	if ResourceLoader.exists(NAME_LIST_RESOURCE_FILE):
		_name_list = load(NAME_LIST_RESOURCE_FILE)
	else:
		_name_list = NameListResource.new()
	_name_list.NAME_LIST.append(pname)
	ResourceSaver.save(_name_list, NAME_LIST_RESOURCE_FILE)

func remove_name_in_name_resource(pname: String) -> void:
	var _name_list: NameListResource
	if not ResourceLoader.exists(NAME_LIST_RESOURCE_FILE):
		return
	_name_list = load(NAME_LIST_RESOURCE_FILE)
	_name_list.NAME_LIST.erase(pname)
	ResourceSaver.save(_name_list, NAME_LIST_RESOURCE_FILE)

func is_config_equals_display(config: PlayerConfig) -> bool:
	var res = true
	res = res and _menu.onready_paths.player_config_display.onready_paths.name.text == config.PLAYER_NAME
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.body.modulate == config.SPRITE_CUSTOMIZATION.BODY_COLOR
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.outline.modulate == config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.eyes.texture.resource_path == config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.eyes.modulate == config.SPRITE_CUSTOMIZATION.EYES_COLOR
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.mouth.texture.resource_path == config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH
	res = res and _menu.onready_paths.player_config_display.onready_paths.player_sprite.onready_paths.mouth.modulate == config.SPRITE_CUSTOMIZATION.MOUTH_COLOR
	res = res and _menu.onready_paths.player_config_display.onready_paths.weapons.primary.texture.resource_path == StaticPrimaryWeaponHandler.get_icon_path(config.PRIMARY_WEAPON)
	res = res and _menu.onready_paths.player_config_display.onready_paths.weapons.powerup.texture.resource_path == StaticPowerupHandler.get_icon_path(config.POWERUP_HANDLER)
	res = res and _menu.onready_paths.player_config_display.onready_paths.weapons.movement_bonus.texture.resource_path == StaticMovementBonusHandler.get_icon_path(config.MOVEMENT_BONUS_HANDLER)
	return res

func update_config(config: PlayerConfig) -> void:
	_menu._update_elements_from_config(config)

func remove_std_preset() -> void:
	remove_preset_with_name(INTEGRATION_TEST_PRESET_NAME)

func remove_preset_with_name(pname: String) -> void:
	var dir_access = DirAccess.open(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	dir_access.remove(pname + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION)

func open_presets_tab() -> void:
	_menu.onready_paths.presets.visible = true

func is_preset_tab_visible() -> bool:
	return _menu.onready_paths.presets.visible

func get_presets() -> Array:
	return _menu.onready_paths.presets.onready_paths.presets_root.get_children()

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

func is_add_preset_button(button: Button) -> bool:
	return button.name == "AddElementButton"

func is_save_preset_popup_visible() -> bool:
	return _menu.onready_paths.save_preset_popup.visible

func save_preset_with_name(pname: String) -> void:
	_menu.onready_paths.save_preset_popup.onready_paths.preset_name.text = pname
	_menu.onready_paths.save_preset_popup.get_ok_button().emit_signal("pressed")

func preset_buttons_contains_preset(preset_buttons: Array, preset: PlayerConfig) -> bool:
	for preset_button in preset_buttons:
		if preset_button.name != "AddElementButton" and is_preset_equal(preset_button, preset):
			return true
	return false

func is_override_preset_popup_visible() -> bool:
	return _menu.get_node("OverridePresetPopup").visible

func override_preset() -> void:
	_menu.get_node("OverridePresetPopup").get_ok_button().emit_signal("pressed")

func open_name_tab() -> void:
	_menu.onready_paths.name.visible = true

func is_name_tab_visible() -> bool:
	return _menu.onready_paths.name.visible

func get_current_name_typed() -> String:
	return _menu.onready_paths.name.onready_paths.current_name.text

func set_name_typed(pname) -> void:
	_menu.onready_paths.name.onready_paths.current_name.text = pname
	_menu.onready_paths.name.onready_paths.current_name.emit_signal("text_changed", pname)

func get_current_name_list() -> Array:
	var item_list = _menu.onready_paths.name.onready_paths.name_list
	var list = []
	for item_idx in range(0, item_list.item_count):
		list.append(item_list.get_item_text(item_idx))
	return list

func select_name(pname: String) -> void:
	var item_list = get_current_name_list()
	if item_list.has(pname):
		var name_idx = item_list.find(pname)
		_menu.onready_paths.name.onready_paths.name_list.select(name_idx)
		_menu.onready_paths.name.onready_paths.name_list.emit_signal("item_activated", name_idx)

func save_name() -> void:
	_menu.onready_paths.name.get_node("VBoxContainer/HBoxContainer/Add").emit_signal("pressed")

func open_elimination_text_tab() -> void:
	_menu.onready_paths.elimination_text.visible = true

func is_elimination_text_tab_visible() -> bool:
	return _menu.onready_paths.elimination_text.visible

func set_elimination_text(text: String) -> void:
	_menu.onready_paths.elimination_text.set_elimination_text(text)
	_menu.onready_paths.elimination_text.onready_paths.text.emit_signal("text_changed", text)

func get_elimination_text() -> String:
	return _menu.onready_paths.elimination_text.get_elimination_text()

func open_customization_tab() -> void:
	_menu.onready_paths.customization.visible = true

func is_customization_tab_visible() -> bool:
	return _menu.onready_paths.customization.visible

func change_main_color(color: Color) -> void:
	_menu.onready_paths.customization.onready_paths.main_color.color = color
	_menu.onready_paths.customization.onready_paths.main_color.emit_signal("color_changed", color)

func is_customization_preview_main_color(color: Color) -> bool:
	var res = true
	res = res and _menu.onready_paths.customization.onready_paths.main_color.color == color
	res = res and _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.body.modulate == color
	return res

func change_secondary_color(color: Color) -> void:
	_menu.onready_paths.customization.onready_paths.secondary_color.color = color
	_menu.onready_paths.customization.onready_paths.secondary_color.emit_signal("color_changed", color)

func is_customization_preview_secondary_color(color: Color) -> bool:
	var res = true
	res = res and _menu.onready_paths.customization.onready_paths.secondary_color.color == color
	res = res and _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.outline.modulate == color
	return res

func change_eyes_color(color: Color) -> void:
	_menu.onready_paths.customization.onready_paths.eyes_color.color = color
	_menu.onready_paths.customization.onready_paths.eyes_color.emit_signal("color_changed", color)

func is_customization_preview_eyes_color(color: Color) -> bool:
	var res = true
	res = res and _menu.onready_paths.customization.onready_paths.eyes_color.color == color
	res = res and _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.eyes.modulate == color
	return res

func change_mouth_color(color: Color) -> void:
	_menu.onready_paths.customization.onready_paths.mouth_color.color = color
	_menu.onready_paths.customization.onready_paths.mouth_color.emit_signal("color_changed", color)

func is_customization_preview_mouth_color(color: Color) -> bool:
	var res = true
	res = res and _menu.onready_paths.customization.onready_paths.mouth_color.color == color
	res = res and _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.mouth.modulate == color
	return res

func change_eyes() -> void:
	_menu.onready_paths.customization.get_node("VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/Eyes/EyesEditButton").emit_signal("pressed")

func is_eyes_selection_menu_visible() -> bool:
	return _menu.onready_paths.customization.onready_paths.eyes_root.visible

func get_eyes_items() -> Array:
	var ret = []
	for item_idx in range(0, _menu.onready_paths.customization.onready_paths.eyes_items.item_count):
		ret.append(_menu.onready_paths.customization.onready_paths.eyes_items.get_item_icon(item_idx))
	return ret

func select_eyes_item(item_idx: int) -> void:
	_menu.onready_paths.customization.onready_paths.eyes_items.select(item_idx)
	_menu.onready_paths.customization.onready_paths.eyes_items.emit_signal("item_activated", item_idx)

func is_eyes_texture_path_equal(path: String) -> bool:
	return path == _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.eyes.texture.resource_path

func change_mouth() -> void:
	_menu.onready_paths.customization.get_node("VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/Mouth/MouthEditButton").emit_signal("pressed")

func is_mouth_selection_menu_visible() -> bool:
	return _menu.onready_paths.customization.onready_paths.mouth_root.visible

func get_mouth_items() -> Array:
	var ret = []
	for item_idx in range(0, _menu.onready_paths.customization.onready_paths.mouth_items.item_count):
		ret.append(_menu.onready_paths.customization.onready_paths.mouth_items.get_item_icon(item_idx))
	return ret

func select_mouth_item(item_idx: int) -> void:
	_menu.onready_paths.customization.onready_paths.mouth_items.select(item_idx)
	_menu.onready_paths.customization.onready_paths.mouth_items.emit_signal("item_activated", item_idx)

func is_mouth_texture_path_equal(path: String) -> bool:
	return path == _menu.onready_paths.customization.onready_paths.sprite_preview.onready_paths.mouth.texture.resource_path

func open_primary_weapon_tab() -> void:
	_menu.onready_paths.primary_weapon.visible = true

func is_primary_weapon_tab_visible() -> bool:
	return _menu.onready_paths.primary_weapon.visible

func select_primary_weapon(idx: int) -> void:
	_menu.onready_paths.primary_weapon.onready_paths.items.select(idx)
	_menu.onready_paths.primary_weapon.onready_paths.items.emit_signal("item_selected", idx)

func is_primary_weapon_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.primary_weapon.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.primary_weapon.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.primary_weapon.onready_paths.description.description.text == element.DESCRIPTION
	return res

func open_movement_bonus_tab() -> void:
	_menu.onready_paths.movement_bonus.visible = true

func is_movement_bonus_tab_visible() -> bool:
	return _menu.onready_paths.movement_bonus.visible

func select_movement_bonus(idx: int) -> void:
	_menu.onready_paths.movement_bonus.onready_paths.items.select(idx)
	_menu.onready_paths.movement_bonus.onready_paths.items.emit_signal("item_selected", idx)

func is_movement_bonus_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.movement_bonus.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.movement_bonus.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.movement_bonus.onready_paths.description.description.text == element.DESCRIPTION
	return res

func open_powerup_tab() -> void:
	_menu.onready_paths.powerup.visible = true

func is_powerup_tab_visible() -> bool:
	return _menu.onready_paths.powerup.visible

func select_powerup(idx: int) -> void:
	_menu.onready_paths.powerup.onready_paths.items.select(idx)
	_menu.onready_paths.powerup.onready_paths.items.emit_signal("item_selected", idx)

func is_powerup_description_equals(element: ItemGridMenuElement) -> bool:
	var res = true
	res = res and _menu.onready_paths.powerup.onready_paths.description.icon.texture.resource_path == element.ICON_PATH
	res = res and _menu.onready_paths.powerup.onready_paths.description.title.text == element.NAME
	res = res and _menu.onready_paths.powerup.onready_paths.description.description.text == element.DESCRIPTION
	return res