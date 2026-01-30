extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/player_customization_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)

##### TESTS #####
# can't really test _ready with the mocks

func test_init_primary_weapon_items():
	# given
	var primary_weapon = create_primary_weapon_mock()
	stub(primary_weapon, "set_items")
	# when
	menu._init_primary_weapon_items()
	# then
	assert_called(primary_weapon, "set_items")
	
func test_init_movement_bonus_items():
	# given
	var movement_bonus = create_movement_bonus_mock()
	stub(movement_bonus, "set_items")
	# when
	menu._init_movement_bonus_items()
	# then
	assert_called(movement_bonus, "set_items")
	

func test_init_powerup_items():
	# given
	var powerup = create_powerup_mock()
	stub(powerup, "set_items")
	# when
	menu._init_powerup_items()
	# then
	assert_called(powerup, "set_items")
	

func test_load_default_config():
	# given
	var default_config = load(StaticUtils.DEFAULT_CONFIG_PATH)
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_player").to_do_nothing()
	var customization = create_customization_mock()
	stub(customization, "update_config").to_do_nothing()
	var name_tab = create_name_mock()
	stub(name_tab, "update_player_name").to_do_nothing()
	var elimination_text = create_elimination_text_mock()
	stub(elimination_text, "set_elimination_text").to_do_nothing()
	# when
	menu._load_default_config()
	# then
	assert_called(player_config_display, "update_player")
	assert_called(customization, "update_config")
	assert_called(name_tab, "update_player_name", [default_config.PLAYER_NAME])
	assert_called(elimination_text, "set_elimination_text", [default_config.ELIMINATION_TEXT])

func test_update_elements_from_config():
	# given
	var config = PlayerConfig.new()
	var sprite_customization = SpriteCustomizationResource.new()
	config.SPRITE_CUSTOMIZATION = sprite_customization
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_player").to_do_nothing()
	var customization = create_customization_mock()
	stub(customization, "update_config").to_do_nothing()
	var name_tab = create_name_mock()
	stub(name_tab, "update_player_name").to_do_nothing()
	var elimination_text = create_elimination_text_mock()
	stub(elimination_text, "set_elimination_text").to_do_nothing()
	# when
	menu._update_elements_from_config(config)
	# then
	assert_called(player_config_display, "update_player", [config])
	assert_called(customization, "update_config", [sprite_customization])
	assert_called(name_tab, "update_player_name", [config.PLAYER_NAME])
	assert_called(elimination_text, "set_elimination_text", [config.ELIMINATION_TEXT])

func test_on_presets_preset_selected():
	var config = PlayerConfig.new()
	var sprite_customization = SpriteCustomizationResource.new()
	config.SPRITE_CUSTOMIZATION = sprite_customization
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_player").to_do_nothing()
	var customization = create_customization_mock()
	stub(customization, "update_config").to_do_nothing()
	var name_tab = create_name_mock()
	stub(name_tab, "update_player_name").to_do_nothing()
	var elimination_text = create_elimination_text_mock()
	stub(elimination_text, "set_elimination_text").to_do_nothing()
	# when
	menu._on_presets_preset_selected(config)
	# then
	assert_eq(menu._current_config, config)
	assert_called(player_config_display, "update_player", [config])
	assert_called(customization, "update_config", [sprite_customization])
	assert_called(name_tab, "update_player_name", [config.PLAYER_NAME])
	assert_called(elimination_text, "set_elimination_text", [config.ELIMINATION_TEXT])

func test_on_name_name_selected():
	# given
	var config = PlayerConfig.new()
	menu._current_config = config
	var t_name = "TestName"
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_name").to_do_nothing()
	# when
	menu._on_name_name_selected(t_name)
	# then
	assert_eq(config.PLAYER_NAME, t_name)
	assert_called(player_config_display, "update_name", [t_name])

func test_on_customization_body_color_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var new_color = Color.RED
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_body").to_do_nothing()
	# when
	menu._on_customization_body_color_changed(new_color)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.BODY_COLOR, new_color)
	assert_called(player_config_display, "update_body", [new_color])

func test_on_customization_eyes_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var eyes_image_path = "res://icon.svg"
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_eyes").to_do_nothing()
	# when
	menu._on_customization_eyes_changed(eyes_image_path)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH, eyes_image_path)
	assert_called(player_config_display, "update_eyes")

func test_on_customization_mouth_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var mouth_image_path = "res://icon.svg"
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_mouth").to_do_nothing()
	# when
	menu._on_customization_mouth_changed(mouth_image_path)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH, mouth_image_path)
	assert_called(player_config_display, "update_mouth")

func test_on_customization_outline_color_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	var new_color = Color.BLUE
	stub(player_config_display, "update_outline").to_do_nothing()
	# when
	menu._on_customization_outline_color_changed(new_color)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR, new_color)
	assert_called(player_config_display, "update_outline", [new_color])

func test_on_primary_weapon_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	item.ITEM_ID = 0
	var config = PlayerConfig.new()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_primary_weapon").to_do_nothing()
	# when
	menu._on_primary_weapon_item_selected(item)
	# then
	assert_eq(config.PRIMARY_WEAPON, 0)
	assert_called(player_config_display, "update_primary_weapon", [0])

func test_on_movement_bonus_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	item.ITEM_ID = 0
	var config = PlayerConfig.new()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_movement_bonus").to_do_nothing()
	# when
	menu._on_movement_bonus_item_selected(item)
	# then
	assert_eq(config.MOVEMENT_BONUS_HANDLER, 0)
	assert_called(player_config_display, "update_movement_bonus", [0])

func test_on_powerup_item_selected():
	# given
	var item = ItemGridMenuElement.new()
	item.ITEM_ID = 0
	var config = PlayerConfig.new()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_powerup").to_do_nothing()
	# when
	menu._on_powerup_item_selected(item)
	# then
	assert_eq(config.POWERUP_HANDLER, 0)
	assert_called(player_config_display, "update_powerup", [0])

func test_on_elimination_text_elimination_text_updated():
	# given
	var config = PlayerConfig.new()
	var text = "elimination text"
	menu._current_config = config
	# when
	menu._on_elimination_text_elimination_text_updated(text)
	# then
	assert_eq(config.ELIMINATION_TEXT, text)

# Can't really test _on_back_button_pressed

func test_on_customization_eyes_color_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_eyes_color").to_do_nothing()
	var new_color = Color.MAROON
	# when
	menu._on_customization_eyes_color_changed(new_color)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.EYES_COLOR, new_color)
	assert_called(player_config_display, "update_eyes_color", [new_color])

func test_on_customization_mouth_color_changed():
	# given
	var config = create_player_config()
	menu._current_config = config
	var player_config_display = create_player_config_display_mock()
	stub(player_config_display, "update_mouth_color").to_do_nothing()
	var new_color = Color.MAROON
	# when
	menu._on_customization_mouth_color_changed(new_color)
	# then
	assert_eq(config.SPRITE_CUSTOMIZATION.MOUTH_COLOR, new_color)
	assert_called(player_config_display, "update_mouth_color", [new_color])

func test_on_save_preset_popup_preset_saved():
	# given
	var presets = create_presets_mock()
	stub(presets, "refresh").to_do_nothing()
	# when
	menu._on_save_preset_popup_preset_saved()
	# then
	assert_called(presets, "refresh")

##### UTILS #####
func create_primary_weapon_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.primary_weapon = mock
	return mock

func create_movement_bonus_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.movement_bonus = mock
	return mock

func create_powerup_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.gd")).new()
	menu.onready_paths.powerup = mock
	return mock

func create_player_config_display_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	menu.onready_paths.player_config_display = mock
	return mock

func create_customization_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerCustomizationMenu/player_customization_tab.gd")).new()
	menu.onready_paths.customization = mock
	return mock

func create_name_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/NameEditMenu/name_edit_menu.gd")).new()
	menu.onready_paths.name = mock
	return mock

func create_elimination_text_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/EliminationTextEditMenu/elimination_text_edit_menu.gd")).new()
	menu.onready_paths.elimination_text = mock
	return mock

func create_presets_mock():
	var mock = double(load("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/presets.gd")).new()
	menu.onready_paths.presets = mock
	return mock

func create_player_config():
	var config = PlayerConfig.new()
	var sprite_customization = SpriteCustomizationResource.new()
	config.SPRITE_CUSTOMIZATION = sprite_customization
	return config
