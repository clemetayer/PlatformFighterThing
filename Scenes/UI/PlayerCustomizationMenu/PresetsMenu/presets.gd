extends MarginContainer
# handles the preset selection menu

##### SIGNALS #####
signal close_triggered
signal preset_selected(preset)

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PRESETS_FOLDER_PATH := "user://PlayerConfigs"

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _presets = []
var _preset_button_load = preload("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/preset.gd")

#==== ONREADY ====
@onready var onready_paths := {
	"presets_root": $"VBoxContainer/ScrollContainer/ElementsList"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_preset_root()
	_presets = _get_presets()
	for preset in _presets:
		_add_preset_button(preset)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _get_presets() -> Array:
	StaticUtils.create_folder_if_not_exists(PRESETS_FOLDER_PATH)
	var presets = []
	for resource in ResourceLoader.list_directory(PRESETS_FOLDER_PATH):
		var res_load = load(resource)
		if res_load is PlayerConfig:
			presets.append(res_load)
	return presets
	
func _reset_preset_root() -> void:
	for element in onready_paths.presets_root.get_children():
		element.queue_free()

func _add_preset_button(preset: PlayerConfig) -> void:
	var button = _preset_button_load.instantiate()
	button.set_preset(preset)
	onready_paths.preset_root.add_child(button)

##### SIGNAL MANAGEMENT #####
func _on_close_button_pressed() -> void:
	emit_signal("close_triggered")
