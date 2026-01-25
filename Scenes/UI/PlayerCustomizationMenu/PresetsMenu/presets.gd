extends MarginContainer
# handles the preset selection menu

##### SIGNALS #####
signal close_triggered
signal preset_selected(preset: PlayerConfig)
signal save_preset_triggered()

##### VARIABLES #####
#---- CONSTANTS -----
const SAVE_PRESET_BUTTON_SCENE := "res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/add_element_button.tscn"

#---- EXPORTS -----
@export var CAN_BE_CLOSED := true
@export var CAN_ADD_ELEMENTS := false

#---- STANDARD -----
#==== PRIVATE ====
var _presets = []
var _preset_button_load = preload("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/preset.tscn")

#==== ONREADY ====
@onready var onready_paths := {
	"presets_root": $"VBoxContainer/ScrollContainer/ElementsList",
	"close_button": $"CloseButton"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.close_button.visible = CAN_BE_CLOSED
	refresh()

##### PUBLIC #####
func refresh() -> void:
	_reset_preset_root()
	_presets = _get_presets()
	for preset in _presets:
		_add_preset_button(preset)
	if CAN_ADD_ELEMENTS:
		_add_save_preset_button()

##### PROTECTED METHODS #####
func _get_presets() -> Array:
	StaticUtils.create_folder_if_not_exists(StaticUtils.USER_CHARACTER_PRESETS_PATH)
	var presets = []
	for resource in ResourceLoader.list_directory(StaticUtils.USER_CHARACTER_PRESETS_PATH):
		var res_load = load(StaticUtils.USER_CHARACTER_PRESETS_PATH + resource)
		if res_load is PlayerConfig:
			presets.append(res_load)
	return presets
	
func _reset_preset_root() -> void:
	for element in onready_paths.presets_root.get_children():
		element.free()

func _add_preset_button(preset: PlayerConfig) -> void:
	var button = _preset_button_load.instantiate()
	onready_paths.presets_root.add_child(button)
	button.set_preset(preset)
	button.connect("pressed", func(): _on_preset_selected(preset))

func _add_save_preset_button() -> void:
	var button = load(SAVE_PRESET_BUTTON_SCENE).instantiate()
	button.connect("pressed", _on_save_preset_button_pressed)
	onready_paths.presets_root.add_child(button)

##### SIGNAL MANAGEMENT #####
func _on_close_button_pressed() -> void:
	emit_signal("close_triggered")

func _on_save_preset_button_pressed() -> void:
	emit_signal("save_preset_triggered")

func _on_preset_selected(player_config: PlayerConfig) -> void:
	emit_signal("preset_selected", player_config)
