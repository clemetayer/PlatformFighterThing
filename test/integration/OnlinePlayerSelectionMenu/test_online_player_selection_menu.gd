extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var scene
var helper
var initial_preset_count
var initial_name_count

##### SETUP #####
func before_all():
	helper = load("res://test/integration/OnlinePlayerSelectionMenu/helper_online_player_selection_menu.gd").new()
	initial_preset_count = helper.count_saved_presets()
	helper.save_std_preset()

func before_each():
	scene = load("res://Scenes/UI/PlayerCustomizationMenu/online_player_selection_menu.tscn").instantiate()
	add_child_autofree(scene)
	await wait_for_signal(scene.tree_entered, 0.1)
	helper.set_customization_menu(scene)

##### TEARDOWN #####
func after_all():
	helper.remove_std_preset()
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
	var total_preset_count = initial_preset_count + 1
	assert_eq(presets.size(), total_preset_count)
	assert_true(helper.preset_buttons_contains_preset(presets, integration_test_config))

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

func test_player_ready():
	# when
	helper.press_ready()
	# then
	assert_false(helper.is_menu_visible())
	assert_true(helper.is_waiting_text_visible())