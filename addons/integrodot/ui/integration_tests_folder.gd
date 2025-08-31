@tool
extends HBoxContainer
# Handles the integration test config folder

##### SIGNALS #####
signal select_integration_tests_folder

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"path": $"LineEdit"
}

##### PUBLIC METHODS #####
func set_integration_test_folder(path : String) -> void:
	onready_paths.path.text = path

func get_integration_test_folder() -> String:
	return onready_paths.path.text

##### SIGNAL MANAGEMENT #####
func _on_select_folder_pressed() -> void:
	emit_signal("select_integration_tests_folder")
