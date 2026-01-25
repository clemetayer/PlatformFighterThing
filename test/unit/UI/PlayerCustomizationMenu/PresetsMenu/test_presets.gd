extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var presets
var close_triggered_times_called := 0
var save_preset_triggered_times_called := 0
var preset_selected_times_called := 0
var preset_selected_args := []

##### SETUP #####
func before_each():
	presets = load("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/presets.tscn").instantiate()
	add_child_autofree(presets)
	await wait_for_signal(presets.tree_entered, 0.1)
	close_triggered_times_called = 0
	save_preset_triggered_times_called = 0
	preset_selected_times_called = 0
	preset_selected_args = []

##### TESTS #####
var ready_params := [
	[true, true],
	[true, false],
	[false, true],
	[false, false],
]
func test_ready(params = use_parameters(ready_params)):
	# given
	var can_be_closed = params[0]
	var can_add_elements = params[1]
	presets.CAN_BE_CLOSED = can_be_closed
	presets.CAN_ADD_ELEMENTS = can_add_elements
	# when
	presets._ready()
	# then
	assert_eq(presets.onready_paths.close_button.visible, can_be_closed)
	assert_eq(presets.onready_paths.presets_root.get_child_count(), presets._presets.size() + 1 if can_add_elements else presets._presets.size())

# refresh, _get_preset, _reset_preset_root, _add_preset_button and _add_save_preset_button tested in _ready

func test_on_close_button_pressed():
	# given
	presets.connect("close_triggered", _on_close_triggered)
	# when
	presets._on_close_button_pressed()
	# then
	assert_eq(close_triggered_times_called, 1)

func test_on_save_button_pressed():
	# given
	presets.connect("save_preset_triggered", _on_save_preset_triggered)
	# when
	presets._on_save_preset_button_pressed()
	# then
	assert_eq(save_preset_triggered_times_called, 1)

func test_on_preset_selected():
	# given
	presets.connect("preset_selected", _on_preset_selected)
	var config = PlayerConfig.new()
	# when
	presets._on_preset_selected(config)
	# then
	assert_eq(preset_selected_times_called, 1)
	assert_eq(preset_selected_args, [[config]])

##### UTILS #####
func _on_preset_selected(config: PlayerConfig) -> void:
	preset_selected_times_called += 1
	preset_selected_args.append([config])

func _on_save_preset_triggered() -> void:
	save_preset_triggered_times_called += 1

func _on_close_triggered() -> void:
	close_triggered_times_called += 1