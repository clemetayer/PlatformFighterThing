@tool
extends HBoxContainer
# Handles the config for the saved inputs folder

##### SIGNALS #####
signal select_saved_inputs_folder

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"path": $"LineEdit"
}

##### PUBLIC METHODS #####
func set_saved_inputs_folder(path : String) -> void:
	onready_paths.path.text = path

func get_saved_inputs_folder() -> String:
	return onready_paths.path.text

##### SIGNAL MANAGEMENT #####
func _on_select_folder_pressed() -> void:
	emit_signal("select_saved_inputs_folder")
