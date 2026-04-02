extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var visualisation
var close_triggered_times_called := 0
var show_ai_presets_triggered_times_called := 0


##### SETUP #####
func before_each():
	visualisation = load("res://Scenes/UI/PlayerCustomizationMenu/AISelectionMenu/ai_visualisation.tscn").instantiate()
	close_triggered_times_called = 0
	show_ai_presets_triggered_times_called = 0


##### TEARDOWN #####
func after_each():
	visualisation.free()


##### TESTS #####
func test_update_ai():
	# given
	var player_display = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerConfigDisplay/player_config_display.gd")).new()
	stub(player_display, "update_player").to_do_nothing()
	var player_config = AIPlayerConfig.new()
	visualisation.player_display = player_display
	# when
	visualisation.update_ai(player_config)
	# then
	assert_called(player_display, "update_player", [player_config])


func test_close_menu_emits_signal():
	# given
	visualisation.close_triggered.connect(_on_close_triggered)
	# when
	visualisation._on_delete_button_pressed()
	# then
	assert_eq(close_triggered_times_called, 1)


func test_show_presets_emit_signal():
	# given
	visualisation.show_ai_presets_triggered.connect(_on_show_ai_presets_triggered)
	# when
	visualisation._on_ai_preset_selection_button_pressed()
	# then
	assert_eq(show_ai_presets_triggered_times_called, 1)


##### UTILS #####
func _on_close_triggered() -> void:
	close_triggered_times_called += 1


func _on_show_ai_presets_triggered() -> void:
	show_ai_presets_triggered_times_called += 1
