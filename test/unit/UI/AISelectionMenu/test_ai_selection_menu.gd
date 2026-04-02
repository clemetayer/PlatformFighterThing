extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var preset_selected_times_called := 0
var preset_selected_args := []
var close_triggered_times_called := 0


##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/AISelectionMenu/ai_selection_menu.tscn").instantiate()
	add_child_autofree(menu)
	close_triggered_times_called = 0
	preset_selected_times_called = 0
	preset_selected_args = []


##### TESTS #####
func test_open():
	# given
	menu.onready_paths.presets.hide()
	menu.onready_paths.visualisation.hide()
	# when
	menu.open()
	# then
	assert_true(menu.onready_paths.presets.visible)
	assert_false(menu.onready_paths.visualisation.visible)


func test_preset_selected():
	# given
	menu.preset_selected.connect(_on_preset_selected)
	var config = PlayerConfig.new()
	var visualisation = double(load("res://Scenes/UI/PlayerCustomizationMenu/AISelectionMenu/ai_visualisation.tscn")).instantiate()
	stub(visualisation, "update_ai").to_do_nothing()
	menu.onready_paths.visualisation = visualisation
	# when
	menu.onready_paths.presets.preset_selected.emit(config)
	# then
	assert_false(menu.onready_paths.presets.visible)
	assert_true(menu.onready_paths.visualisation.visible)
	assert_called(visualisation, "update_ai", [config])
	assert_eq(preset_selected_times_called, 1)
	assert_eq(preset_selected_args, [[config]])


func test_close_triggered():
	# given
	menu.close_triggered.connect(_on_close_triggered)
	# when
	menu.onready_paths.visualisation.close_triggered.emit()
	# then
	assert_eq(close_triggered_times_called, 1)


func test_show_presets_triggered():
	# given
	# when
	menu.onready_paths.visualisation.show_ai_presets_triggered.emit()
	# then
	assert_true(menu.onready_paths.presets.visible)
	assert_false(menu.onready_paths.visualisation.visible)


##### UTILS #####
func _on_close_triggered() -> void:
	close_triggered_times_called += 1


func _on_preset_selected(preset: PlayerConfig) -> void:
	preset_selected_times_called += 1
	preset_selected_args.append([preset])
