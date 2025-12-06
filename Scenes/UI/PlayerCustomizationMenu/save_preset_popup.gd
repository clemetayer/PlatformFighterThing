extends ConfirmationDialog
# Popup to handle the saving of a preset

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _preset_to_save: PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"preset_name": $"VBoxContainer/LineEdit",
	"override_preset_popup": $"../OverridePresetPopup"
}

##### PUBLIC METHODS #####
func set_preset_to_save(preset: PlayerConfig) -> void:
	_preset_to_save = preset

##### PROTECTED METHODS #####
func _save_preset() -> void:
	GSLogger.info("saving preset to %s" % _get_preset_save_path())
	ResourceSaver.save(_preset_to_save, _get_preset_save_path())

func _get_preset_save_path() -> String:
	return StaticUtils.USER_CHARACTER_PRESETS_PATH + onready_paths.preset_name.text + StaticUtils.GODOT_RESOURCE_FILE_EXTENSION

##### SIGNAL MANAGEMENT #####
func _on_confirmed() -> void:
	if onready_paths.preset_name.text.length() > 0:
		if ResourceLoader.exists(_get_preset_save_path()):
			onready_paths.override_preset_popup.show()
		else:
			_save_preset()
		hide()

func _on_override_preset_popup_confirmed() -> void:
	_save_preset()
