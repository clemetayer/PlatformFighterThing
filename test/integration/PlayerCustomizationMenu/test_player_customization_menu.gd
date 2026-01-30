extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var scene
var helper
var initial_preset_count
var initial_name_count

##### SETUP #####
func before_all():
	helper = load("res://test/integration/PlayerCustomizationMenu/helper_player_customization_menu.gd").new()
	initial_preset_count = helper.count_saved_presets()
	initial_name_count = helper.count_saved_names()
	helper.save_std_preset()
	helper.add_name_in_name_resource(helper.INTEGRATION_TEST_NAME)

func before_each():
	scene = load("res://Scenes/UI/PlayerCustomizationMenu/player_customization_menu.tscn").instantiate()
	add_child_autofree(scene)
	await wait_for_signal(scene.tree_entered, 0.1)
	helper.set_customization_menu(scene)

##### TEARDOWN #####
func after_all():
	helper.remove_std_preset()
	helper.remove_name_in_name_resource(helper.INTEGRATION_TEST_NAME)
	await wait_seconds(0.1)
	helper.free()

##### TESTS #####
func test_player_config():
	# given
	var config = load(StaticUtils.DEFAULT_CONFIG_PATH)
	# when / then
	assert_true(helper.is_config_equals_display(config))
	# when
	config = load(helper.INTEGRATION_TEST_PRESET_PATH)
	helper.update_config(config)
	# then
	assert_true(helper.is_config_equals_display(config))

func test_presets():
	# when
	helper.open_presets_tab()
	# then
	assert_true(helper.is_preset_tab_visible())
	var integration_test_config = helper.get_integration_test_config()
	var presets = helper.get_presets()
	var total_preset_count = initial_preset_count + 2 # including the "add preset" button
	assert_eq(presets.size(), total_preset_count)
	assert_true(helper.preset_buttons_contains_preset(presets, integration_test_config))
	assert_true(helper.is_add_preset_button(presets[total_preset_count - 1]))
	# when
	presets[total_preset_count - 1].emit_signal("pressed")
	await wait_process_frames(3)
	# then
	assert_true(helper.is_save_preset_popup_visible())
	# when
	helper.save_preset_with_name(helper.INTEGRATION_TEST_2_PRESET_NAME)
	await wait_seconds(0.5)
	# then
	presets = helper.get_presets()
	assert_eq(presets.size(), initial_preset_count + 3)
	# when
	presets[total_preset_count - 1].emit_signal("pressed")
	await wait_process_frames(3)
	helper.save_preset_with_name(helper.INTEGRATION_TEST_2_PRESET_NAME)
	assert_true(helper.is_override_preset_popup_visible())
	helper.override_preset()
	await wait_seconds(0.5)
	assert_eq(presets.size(), initial_preset_count + 3)
	# cleanup 
	helper.remove_preset_with_name(helper.INTEGRATION_TEST_2_PRESET_NAME)

func test_name():
	# when
	helper.open_name_tab()
	# then
	assert_true(helper.is_name_tab_visible())
	assert_eq(helper.get_current_name_typed(), "player")
	# when
	helper.set_name_typed("integ")
	await wait_process_frames(3)
	# then
	var name_list = helper.get_current_name_list()
	assert_true(name_list.has(helper.INTEGRATION_TEST_NAME))
	# when
	helper.select_name(helper.INTEGRATION_TEST_NAME)
	await wait_process_frames(3)
	# then
	assert_eq(helper.get_current_name_typed(), helper.INTEGRATION_TEST_NAME)
	assert_eq(helper.get_current_menu_config().PLAYER_NAME, helper.INTEGRATION_TEST_NAME)
	# when
	helper.set_name_typed(helper.INTEGRATION_TEST_NAME_2)
	await wait_process_frames(3)
	# then
	name_list = helper.get_current_name_list()
	assert_false(name_list.has(helper.INTEGRATION_TEST_NAME))
	assert_false(name_list.has(helper.INTEGRATION_TEST_NAME_2))
	# when
	helper.save_name()
	await wait_seconds(0.5)
	# then
	name_list = helper.get_current_name_list()
	assert_true(name_list.has(helper.INTEGRATION_TEST_NAME_2))
	assert_eq(helper.get_current_menu_config().PLAYER_NAME, helper.INTEGRATION_TEST_NAME_2)
	# when
	helper.set_name_typed("integ")
	await wait_process_frames(3)
	# then
	name_list = helper.get_current_name_list()
	assert_true(name_list.has(helper.INTEGRATION_TEST_NAME))
	assert_true(name_list.has(helper.INTEGRATION_TEST_NAME_2))
	# cleanup
	helper.remove_name_in_name_resource(helper.INTEGRATION_TEST_NAME_2)

func test_elimination_text():
	# when
	helper.open_elimination_text_tab()
	# then
	assert_true(helper.is_elimination_text_tab_visible())
	# when
	var elimination_text = "elimination_text"
	helper.set_elimination_text(elimination_text)
	# then
	assert_eq(helper.get_elimination_text(), elimination_text)
	assert_eq(helper.get_current_menu_config().ELIMINATION_TEXT, elimination_text)

func test_customization():
	# when
	helper.open_customization_tab()
	# then
	assert_true(helper.is_customization_tab_visible())
	# when
	helper.change_main_color(Color.RED)
	# then
	assert_true(helper.is_customization_preview_main_color(Color.RED))
	# when
	helper.change_secondary_color(Color.BLUE)
	# then
	assert_true(helper.is_customization_preview_secondary_color(Color.BLUE))
	# when
	helper.change_eyes_color(Color.ORANGE)
	# then
	assert_true(helper.is_customization_preview_eyes_color(Color.ORANGE))
	# when
	helper.change_mouth_color(Color.TEAL)
	# then
	assert_true(helper.is_customization_preview_mouth_color(Color.TEAL))
	# when
	helper.change_eyes()
	await wait_process_frames(3)
	# then
	assert_true(helper.is_eyes_selection_menu_visible())
	var eyes = helper.get_eyes_items()
	# when
	helper.select_eyes_item(1)
	# then 
	assert_false(helper.is_eyes_selection_menu_visible())
	assert_true(helper.is_eyes_texture_path_equal(eyes[1].resource_path))
	# when
	helper.change_mouth()
	await wait_process_frames(3)
	# then
	assert_true(helper.is_mouth_selection_menu_visible())
	var mouths = helper.get_mouth_items()
	# when
	helper.select_mouth_item(1)
	# then 
	assert_false(helper.is_mouth_selection_menu_visible())
	assert_true(helper.is_mouth_texture_path_equal(mouths[1].resource_path))

func test_primary_weapon_selection():
	# when
	helper.open_primary_weapon_tab()
	# then
	assert_true(helper.is_primary_weapon_tab_visible())
	# when
	helper.select_primary_weapon(0)
	# then
	assert_true(helper.is_primary_weapon_description_equals(StaticItemDescriptions.get_primary_weapons_descriptions()[0]))

func test_movement_bonus_selection():
	# when
	helper.open_movement_bonus_tab()
	# then
	assert_true(helper.is_movement_bonus_tab_visible())
	# when
	helper.select_movement_bonus(0)
	# then
	assert_true(helper.is_movement_bonus_description_equals(StaticItemDescriptions.get_movement_bonus_descriptions()[0]))

func test_powerup_selection():
	# when
	helper.open_powerup_tab()
	# then
	assert_true(helper.is_powerup_tab_visible())
	# when
	helper.select_powerup(0)
	# then
	assert_true(helper.is_powerup_description_equals(StaticItemDescriptions.get_powerups_descriptions()[0]))
